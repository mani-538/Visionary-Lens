from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from backend.app.database.db_connection import SessionLocal
from backend.app.database.models import Document, Summary
from backend.app.schemas.ai_schema import AISummarizeRequest, AIExplainRequest, AIResponse
from backend.app.services.ai_service import AIService
from backend.app.services.auth_dependency import verify_token

router = APIRouter(prefix="/ai", tags=["AI Features"])
ai_service = AIService()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/summarize", response_model=AIResponse)
async def summarize(
    request: AISummarizeRequest,
    db: Session = Depends(get_db),
    token_data: dict = Depends(verify_token)
):
    doc = db.query(Document).filter(Document.id == request.document_id).first()
    if not doc or not doc.extracted_text:
        raise HTTPException(status_code=400, detail="Document not found or text not extracted yet")

    # Only owner can summarize
    if doc.user_id != token_data.get("user_id"):
        raise HTTPException(status_code=403, detail="Not authorized")

    summary_text = await ai_service.summarize_text(doc.extracted_text)
    
    # Save to DB
    new_summary = Summary(document_id=doc.id, summary_text=summary_text)
    db.add(new_summary)
    db.commit()
    
    return {"document_id": doc.id, "result": summary_text}

@router.post("/explain-diagram", response_model=AIResponse)
async def explain_diagram(
    request: AIExplainRequest,
    db: Session = Depends(get_db),
    token_data: dict = Depends(verify_token)
):
    doc = db.query(Document).filter(Document.id == request.document_id).first()
    if not doc:
        raise HTTPException(status_code=404, detail="Document not found")
    
    explanation = await ai_service.explain_diagram(doc.image_url)
    return {"document_id": doc.id, "result": explanation}

@router.post("/explain-formula", response_model=AIResponse)
async def explain_formula(
    request: AIExplainRequest,
    db: Session = Depends(get_db),
    token_data: dict = Depends(verify_token)
):
    doc = db.query(Document).filter(Document.id == request.document_id).first()
    if not doc:
        raise HTTPException(status_code=404, detail="Document not found")
    
    # Use image for formula extraction/explanation if text is insufficient
    explanation = await ai_service.explain_formula(doc.image_url, is_image=True)
    return {"document_id": doc.id, "result": explanation}

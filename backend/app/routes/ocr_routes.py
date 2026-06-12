from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from backend.app.database.db_connection import SessionLocal
from backend.app.database.models import Document
from backend.app.schemas.ocr_schema import OCRExtractRequest, OCRExtractResponse
from backend.app.services.ai_service import AIService
from backend.app.services.auth_dependency import verify_token

router = APIRouter(prefix="/ocr", tags=["OCR"])
ai_service = AIService()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/extract", response_model=OCRExtractResponse)
async def extract_text(
    request: OCRExtractRequest,
    db: Session = Depends(get_db),
    token_data: dict = Depends(verify_token)
):
    doc = db.query(Document).filter(Document.id == request.document_id).first()
    if not doc:
        raise HTTPException(status_code=404, detail="Document not found")

    # Check ownership
    if doc.user_id != token_data.get("user_id"):
        raise HTTPException(status_code=403, detail="Not authorized to access this document")

    try:
        extracted_text = await ai_service.extract_text_from_image(doc.image_url)
        
        # Update document with extracted text
        doc.extracted_text = extracted_text
        db.commit()
        
        return {
            "document_id": doc.id,
            "extracted_text": extracted_text
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"OCR Extraction failed: {str(e)}")

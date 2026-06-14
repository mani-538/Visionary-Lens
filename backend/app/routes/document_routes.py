import os
import shutil
from typing import List
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File
from sqlalchemy.orm import Session

from backend.app.database.db_connection import SessionLocal
from backend.app.database.models import Document, User
from backend.app.schemas.document_schema import DocumentResponse
from backend.app.services.auth_dependency import verify_token

router = APIRouter(prefix="/documents", tags=["Documents"])

UPLOAD_DIR = "uploads"

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/upload", response_model=DocumentResponse)
async def upload_document(
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    token_data: dict = Depends(verify_token)
):
    user_id = token_data.get("user_id")
    if not user_id:
        raise HTTPException(status_code=401, detail="User ID not found in token")

    # Cloudinary Integration or Local Fallback
    import cloudinary
    import cloudinary.uploader
    import cloudinary.api
    from dotenv import load_dotenv

    load_dotenv()
    
    file_extension = os.path.splitext(file.filename)[1]
    safe_filename = f"{user_id}_{os.urandom(8).hex()}{file_extension}"
    
    if os.getenv("CLOUDINARY_URL"):
        # Upload to Cloudinary directly from memory
        result = cloudinary.uploader.upload(file.file)
        file_path = result.get("secure_url")
    else:
        # Save file locally for now as fallback
        file_path = os.path.join(UPLOAD_DIR, safe_filename)
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)

    new_doc = Document(
        user_id=user_id,
        image_url=file_path,  # Cloudinary URL or Local path
        extracted_text=""     # Placeholder for OCR
    )

    db.add(new_doc)
    db.commit()
    db.refresh(new_doc)

    return new_doc

@router.get("/{document_id}", response_model=DocumentResponse)
def get_document(
    document_id: int,
    db: Session = Depends(get_db),
    token_data: dict = Depends(verify_token)
):
    doc = db.query(Document).filter(Document.id == document_id).first()
    if not doc:
        raise HTTPException(status_code=404, detail="Document not found")
    
    # Check ownership
    if doc.user_id != token_data.get("user_id"):
        raise HTTPException(status_code=403, detail="Not authorized to access this document")
    
    return doc

@router.delete("/{document_id}")
def delete_document(
    document_id: int,
    db: Session = Depends(get_db),
    token_data: dict = Depends(verify_token)
):
    doc = db.query(Document).filter(Document.id == document_id).first()
    if not doc:
        raise HTTPException(status_code=404, detail="Document not found")
    
    # Check ownership
    if doc.user_id != token_data.get("user_id"):
        raise HTTPException(status_code=403, detail="Not authorized to delete this document")

    # Remove local file
    if os.path.exists(doc.image_url):
        os.remove(doc.image_url)

    db.delete(doc)
    db.commit()

    return {"message": "Document deleted successfully"}

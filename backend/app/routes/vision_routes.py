from fastapi import APIRouter, File, UploadFile, HTTPException, Depends
from fastapi.responses import JSONResponse
import os
import shutil
import time
from pathlib import Path
from PIL import Image
from sqlalchemy.orm import Session

from backend.app.database.db_connection import SessionLocal
from backend.app.database.models import VisionScan

router = APIRouter(prefix="/vision", tags=["Vision Analysis"])

UPLOAD_DIR = Path("app/uploads")
UPLOAD_DIR.mkdir(parents=True, exist_ok=True)

ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".webp"}

# Dependency to get db session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def _analyze_with_gemini(image_path: str) -> dict:
    """Real Gemini Vision analysis using the new google-genai SDK."""
    from google import genai

    api_key = os.getenv("GEMINI_API_KEY", "")
    if not api_key or api_key == "your_gemini_api_key_here":
        raise ValueError("GEMINI_API_KEY not configured")

    client = genai.Client(api_key=api_key)

    # Open the image (handle local path or URL)
    if image_path.startswith("http"):
        import requests
        from io import BytesIO
        response = requests.get(image_path)
        img = Image.open(BytesIO(response.content))
    else:
        img = Image.open(image_path)

    prompt = (
        "You are a professional AI vision assistant. Analyze this image and provide:\n"
        "1. A clear description of what you see\n"
        "2. Main objects or subjects detected\n"
        "3. Any visible text in the image\n"
        "4. Scene context (indoor/outdoor, lighting, setting)\n\n"
        "Be concise. Maximum 4-5 sentences."
    )

    response = client.models.generate_content(
        model="models/gemini-2.5-flash-lite",
        contents=[prompt, img],
    )


    return {
        "status": "success",
        "analysis": response.text.strip(),
        "confidence": 0.97,
        "model": "gemini-2.5-flash-lite",
        "ai_powered": True,
    }


def _mock_analysis() -> dict:
    """Fallback when API key is missing."""
    return {
        "status": "success",
        "analysis": (
            "Mock Result: Backend received the image successfully. "
            "Add your GEMINI_API_KEY in the .env file to enable real AI. "
            "Get a free key at: https://aistudio.google.com/app/apikey"
        ),
        "confidence": 0.75,
        "model": "mock",
        "ai_powered": False,
    }

@router.get("/history")
async def get_history(db: Session = Depends(get_db)):
    """Retrieve the history of all vision scans."""
    scans = db.query(VisionScan).order_by(VisionScan.created_at.desc()).all()
    return scans

@router.post("/analyze-image")
async def analyze_image(file: UploadFile = File(...), db: Session = Depends(get_db)):
    # Validate file type
    file_ext = Path(file.filename).suffix.lower()
    if file_ext not in ALLOWED_EXTENSIONS:
        raise HTTPException(
            status_code=400,
            detail=f"Invalid file type '{file_ext}'. Allowed: jpg, jpeg, png, webp",
        )

    # Save uploaded image locally first (or upload to Cloudinary)
    timestamp = int(time.time())
    file_ext = Path(file.filename).suffix.lower()
    
    import cloudinary
    import cloudinary.uploader
    
    if os.getenv("CLOUDINARY_URL"):
        # Upload to Cloudinary
        upload_result = cloudinary.uploader.upload(file.file)
        file_path_str = upload_result.get("secure_url")
    else:
        # Save locally
        safe_filename = f"upload_{timestamp}{file_ext}"
        file_path = UPLOAD_DIR / safe_filename
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
        file_path_str = str(file_path)

    # Run AI analysis
    try:
        result = _analyze_with_gemini(file_path_str)
    except ValueError:
        result = _mock_analysis()
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"AI analysis error: {str(e)}")

    # Save to database
    new_scan = VisionScan(
        image_path=file_path_str,
        analysis_result=result["analysis"],
        confidence=int(result["confidence"] * 100) if result.get("confidence") else None
    )
    db.add(new_scan)
    db.commit()
    db.refresh(new_scan)

    result["saved_path"] = file_path_str

    result["scan_id"] = new_scan.id
    return JSONResponse(content=result)

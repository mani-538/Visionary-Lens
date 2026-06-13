from fastapi import APIRouter, Depends, HTTPException
from fastapi.responses import FileResponse
from pydantic import BaseModel

from backend.app.services.tts_service import TTSService
from backend.app.services.auth_dependency import verify_token

router = APIRouter(prefix="/tts", tags=["Text-to-Speech"])
tts_service = TTSService()

class TTSRequest(BaseModel):
    text: str
    language: str = "en"

@router.post("/generate")
async def generate_speech(
    request: TTSRequest,
    token_data: dict = Depends(verify_token)
):
    try:
        audio_path = await tts_service.text_to_speech(request.text, request.language)
        return {"audio_url": audio_path, "message": "Speech generated successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"TTS Generation failed: {str(e)}")

@router.get("/stream/{filename}")
async def stream_speech(filename: str):
    import os
    filepath = os.path.join("audio", filename)
    if not os.path.exists(filepath):
        raise HTTPException(status_code=404, detail="Audio file not found")
    
    return FileResponse(filepath, media_type="audio/mpeg")

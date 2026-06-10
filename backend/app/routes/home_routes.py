from fastapi import APIRouter, Depends
from backend.app.services.auth_dependency import verify_token

router = APIRouter()

@router.get("/")
def home(user=Depends(verify_token)):
    return {
        "message": "Visionary Lens Backend Running (Protected)",
        "user": user
    }
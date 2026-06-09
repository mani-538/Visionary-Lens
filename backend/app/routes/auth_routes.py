from fastapi import APIRouter
from backend.app.schemas.user_schema import UserRegister
from backend.app.schemas.user_schema import UserRegister, UserLogin

router = APIRouter(prefix="/auth", tags=["Authentication"])


@router.post("/register")
def register(user: UserRegister):
    return {
        "message": "User registration endpoint working",
        "user": user
    }

@router.post("/login")
def login(user: UserLogin):
    return {
        "message": "Login endpoint working",
        "email": user.email
    }
from fastapi import APIRouter
from backend.app.schemas.user_schema import UserRegister, UserLogin, PasswordResetRequest

from backend.app.services.auth_service import hash_password

from backend.app.database.db_connection import SessionLocal
from backend.app.database.models import User
from backend.app.services.auth_service import hash_password

from backend.app.services.auth_service import verify_password

from backend.app.services.jwt_service import create_access_token

router = APIRouter(prefix="/auth", tags=["Authentication"])


@router.post("/register")
def register(user: UserRegister):
    db = SessionLocal()

    hashed_pwd = hash_password(user.password)

    new_user = User(
        full_name=user.full_name,
        email=user.email,
        password_hash=hashed_pwd
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    db.close()

    return {
        "message": "User registered successfully",
        "user": {
            "id": new_user.id,
            "full_name": new_user.full_name,
            "email": new_user.email
        }
    }

@router.post("/login")
def login(user: UserLogin):
    db = SessionLocal()

    db_user = db.query(User).filter(User.email == user.email).first()

    if not db_user:
        db.close()
        return {"message": "Invalid email or password"}

    if not verify_password(user.password, db_user.password_hash):
        db.close()
        return {"message": "Invalid email or password"}

    db.close()

    token = create_access_token(
    data={"user_id": db_user.id, "email": db_user.email}
)
    
    return {
        "message": "Login successful",
    "access_token": token,
    "token_type": "bearer",
    "user": {
        "id": db_user.id,
        "email": db_user.email,
        "full_name": db_user.full_name
        }
    }

@router.post("/logout")
def logout():
    # In a stateless JWT setup, logout is primarily handled by the client 
    # (deleting the token). Here we return a confirmation.
    return {"message": "Successfully logged out"}

@router.post("/reset-password")
def reset_password(request: PasswordResetRequest):
    db = SessionLocal()
    db_user = db.query(User).filter(User.email == request.email).first()
    
    if not db_user:
        db.close()
        return {"message": "User not found"}
    
    db_user.password_hash = hash_password(request.new_password)
    db.commit()
    db.close()
    
    return {"message": "Password reset successfully"}
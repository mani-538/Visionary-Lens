from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from backend.app.routes.home_routes import router as home_router
from backend.app.routes.auth_routes import router as auth_router
from backend.app.routes.document_routes import router as document_router
from backend.app.routes.ocr_routes import router as ocr_router
from backend.app.routes.ai_routes import router as ai_router
from backend.app.routes.tts_routes import router as tts_router

from backend.app.database.db_connection import engine, Base
from backend.app.database import models

app = FastAPI(title="Visionary Lens 2.0 API")

# CORS Configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # For production, replace with specific domains like ["https://visionary-lens.app"]
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/health")
def health_check():
    return {"status": "healthy", "version": "2.0.0"}

app.include_router(home_router)
app.include_router(auth_router)
app.include_router(document_router)
app.include_router(ocr_router)
app.include_router(ai_router)
app.include_router(tts_router)

@app.on_event("startup")
def on_startup():
    Base.metadata.create_all(bind=engine)
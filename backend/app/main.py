from fastapi import FastAPI
from backend.app.routes.home_routes import router as home_router
from backend.app.routes.auth_routes import router as auth_router
from backend.app.routes.document_routes import router as document_router
from backend.app.routes.ocr_routes import router as ocr_router

from backend.app.database.db_connection import engine, Base
from backend.app.database import models

app = FastAPI()

app.include_router(home_router)
app.include_router(auth_router)
app.include_router(document_router)
app.include_router(ocr_router)

@app.on_event("startup")
def on_startup():
    Base.metadata.create_all(bind=engine)
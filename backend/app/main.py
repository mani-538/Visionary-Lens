from fastapi import FastAPI
from backend.app.routes.home_routes import router as home_router
from backend.app.routes.auth_routes import router as auth_router

app = FastAPI()

app.include_router(home_router)
app.include_router(auth_router)
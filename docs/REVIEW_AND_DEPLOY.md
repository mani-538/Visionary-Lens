# Review and Deployment Guide - Visionary Lens

## 1. How to Review the Project

### 1.1 Backend Review (FastAPI)
- **Code Logic:** Review `backend/app/services/ai_service.py` to see how Gemini is prompted for OCR, Summaries, and Explanations.
- **Security:** Check `auth_dependency.py` and `jwt_service.py` to ensure token-based protection is active on sensitive routes.
- **API Documentation:**
  1. Start the backend: `uvicorn backend.app.main:app --reload`
  2. Open your browser and go to `http://127.0.0.1:8000/docs`.
  3. This will show the interactive Swagger UI where you can test all endpoints (Login, Upload, OCR, AI) directly.

### 1.2 Frontend Review (Flutter)
- **Accessibility:** Ensure that semantic labels and TTS feedbacks are present in `lib/views/`.
- **State Management:** Review `lib/providers/` to see how the app handles authentication and document processing states.
- **Theme:** Check `lib/main.dart` for the High-Contrast dark theme.

---

## 2. Deployment Guide

### 2.1 Backend Deployment (e.g., Render or Railway)
FastAPI is easy to deploy on platforms like Render.com:
1. **Push to GitHub:** Initialize a git repo and push the `Visionary-Lens` folder.
2. **Create New Web Service:** Connect your GitHub repo to Render.
3. **Build Command:** `pip install -r backend/requirements.txt`
4. **Start Command:** `uvicorn backend.app.main:app --host 0.0.0.0 --port $PORT`
5. **Environment Variables:** Add all variables from `backend/.env.example` to the Render Dashboard (especially `GEMINI_API_KEY`).

### 2.2 Database Migration (Sqlite to PostgreSQL)
The project currently uses SQLite for simplicity. For a production deployment:
1. Change `DATABASE_URL` in your `.env` to a PostgreSQL connection string.
2. SQLAlchemy will handle the table creation on startup.

### 2.3 Image Storage (Local to Cloudinary)
Currently, images are stored in the `/uploads` folder. For cloud deployment:
1. Create a Cloudinary account.
2. Update the `upload_document` route in `document_routes.py` to use the `cloudinary` Python SDK to upload files and store the resulting secure URL in the database.

### 2.4 Frontend Deployment (Generating APK)
Since this is a Flutter app for visually impaired users, an Android APK is the most common delivery method:
1. **Install Flutter:** Ensure Flutter SDK is installed on your machine.
2. **Build APK:**
   ```powershell
   cd frontend
   flutter build apk --release
   ```
3. **Distribute:** The resulting APK will be in `build/app/outputs/flutter-apk/app-release.apk`. Transfer this to an Android phone to test with TalkBack and the app's internal voice assistant.

---

## 3. Final Verification Checklist
- [ ] Gemini API Key is valid and has billing/quota space.
- [ ] Backend is accessible via a public URL (or local IP for home testing).
- [ ] `baseUrl` in Flutter's `api_service.dart` is updated to point to the live backend.
- [ ] TTS and Speech-to-Text permissions are granted in the mobile app.

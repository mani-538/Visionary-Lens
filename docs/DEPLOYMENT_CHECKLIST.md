# DEPLOYMENT CHECKLIST - Visionary Lens

Ensure all the following steps are completed before initiating the final production deployment.

## 1. Project Configuration
- [ ] Ensure `render.yaml` is present in the root of the repository.
- [ ] Validate that `backend/requirements.txt` contains all necessary dependencies (`psycopg2-binary`, `cloudinary`, `fastapi`, `uvicorn`, `google-generativeai`).
- [ ] Confirm `main.py` explicitly allows CORS from your expected frontend domains or wildcard `["*"]` for mobile apps.
- [ ] Ensure the database connection strategy utilizes `DATABASE_URL` for PostgreSQL dynamic injection.

## 2. Infrastructure Setup
- [ ] **GitHub:** Ensure the codebase is pushed to a private GitHub repository.
- [ ] **Supabase (PostgreSQL):** PostgreSQL database has been created via Supabase. Note down the Transaction Pooler connection string.
- [ ] **Cloudinary:** A free Cloudinary account is created. Note down the `CLOUDINARY_URL` from the Dashboard.
- [ ] **Google AI Studio:** Ensure you have generated a production `GEMINI_API_KEY`.

## 3. Render Setup
- [ ] Create an account on Render.com and authorize GitHub.
- [ ] Create a new "Web Service" from your GitHub repository using the `render.yaml` or UI configurations.
- [ ] Input all necessary required environment variables safely into Render's Environment Variable settings.

## 4. Frontend Release Configuration
- [ ] Update `baseUrl` in `frontend/lib/services/api_service.dart` to the new Render deployment URL.
- [ ] Verify `android/app/build.gradle` has the correct `minSdkVersion` and configurations.
- [ ] Run `flutter build apk --release` for Android to test the build logic locally.

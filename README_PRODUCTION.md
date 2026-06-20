# Visionary Lens 2.0 Production Guide

This guide contains instructions to run and deploy the complete Visionary Lens 2.0 system.

## 📱 Mobile App (Flutter)

### Prerequisites
- Flutter SDK (latest stable)
- Android SDK / Real Device

### Setup
1. Navigate to `mobile/`.
2. Run `flutter pub get`.
3. Open `lib/core/constants.dart` and ensure `baseUrl` matches your machine's Local IP.

### Running
```bash
flutter run
```

---

## 🖥 Backend (FastAPI)

### Prerequisites
- Python 3.10+
- Virtual Environment

### Setup
1. Navigate to root or `backend/`.
2. Install dependencies:
   ```bash
   pip install -r backend/requirements.txt
   ```
3. Update `.env` with your `GEMINI_API_KEY`.

### Running
```bash
venv\Scripts\python -m uvicorn backend.app.main:app --host 0.0.0.0 --port 8000 --reload
```

---

## 🏗 Features Included
- **Authentication**: JWT-based login and registration.
- **AI Analysis**: Powered by Google Gemini.
- **History**: Local SQLite storage of all scans.
- **Accessibility**: Narrated results via Text-to-Speech (TTS).

Developed by Antigravity AI.

# Software Requirements Specification (SRS) - Visionary Lens

## 1. Introduction
Visionary Lens is an AI-powered accessibility application designed to assist visually impaired students in accessing printed academic materials independently.

## 2. Product Vision
To bridge the gap between printed educational content and visually impaired students using state-of-the-art AI (FastAPI, Gemini Vision, and Flutter).

## 3. Functional Requirements
### 3.1 Authentication
- User Registration and Login via Email/Password.
- JWT-based session management.

### 3.2 Document Scanning & OCR
- Voice-guided camera centering.
- High-accuracy text extraction from images using Gemini Vision.

### 3.3 AI Interaction
- Contextual Q&A (Ask My Notes).
- Automated summarization of academic topics.
- Diagram description for scientific charts.
- Formula translation into spoken language.

### 3.4 Study Assistant
- Generation of flashcards from scanned notes.
- Creation of personalized quizzes based on document content.

## 4. Non-Functional Requirements
- **Accessibility:** 100% voice-operable interface with high-contrast UI.
- **Performance:** AI processing (OCR/Summarization) should complete within 5-10 seconds.
- **Security:** Hashed passwords and secure local storage for tokens.

## 5. Tech Stack
- **Frontend:** Flutter
- **Backend:** FastAPI (Python)
- **Database:** SQLite (SQLAlchemy)
- **AI Engine:** Google Gemini AI
- **TTS Engine:** gTTS / Flutter TTS

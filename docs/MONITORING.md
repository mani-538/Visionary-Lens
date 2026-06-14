# MONITORING AND LOGGING RECOMMENDATIONS

For production-level maintainability of Visionary Lens.

## 1. Fast API Logging
FastAPI utilizes Python's robust native `logging`. However, unstructured logs can be difficult to query at scale.
- **Action**: Implement JSON-formatted logging using `structlog`. This enables platforms like DataDog or Render Log Streams to index and search requests efficiently.

## 2. Platform Monitoring (Render/Supabase)
- **Render Dashboard**: Render automatically monitors CPU and Memory limits. Set alerts within your Render dashboard if CPU spikes exist over 90% repeatedly, it may imply OCR processing threads are locking.
- **Supabase Metrics**: Monitor Supabase's API connections specifically so your connections don't exhaust limits (why connection pooler URLs are mandatory).

## 3. Sentry Error Tracking
- **Action**: Integrate Sentry into both the Flutter Frontend and FastAPI Backend.
- **Benefit**: Should a user encounter an unhandled extraction format from Gemini, it will log the specific error trace directly to Sentry avoiding "silent crashes" for the visually impaired user.
- **Implementation**: `pip install sentry-sdk` and initialize within `main.py` using `sentry_sdk.init(dsn="YOUR_DSN")`.

## 4. User Telemetry (Optional/Privacy Heavy)
Because this application is developed for accessibility, identifying UX bottlenecks relies on knowing where users frequently pause or restart workflows. 
- Ensure telemetry only tracks completely anonymized action hooks (e.g., "Scan triggered") with explicit Opt-In conditions suitable for screen readers.

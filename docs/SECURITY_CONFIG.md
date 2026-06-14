# PRODUCTION SECURITY RECOMMENDATIONS - Visionary Lens

Before public distribution, these security hardening steps should be actively considered or enforced.

## 1. Secrets Management
- **Never Commit `.env`**: Make absolutely sure that the `.env` file does not end up in version control. Keep `.gitignore` updated.
- **Rotate JWT Keys**: Your `SECRET_KEY` should be a randomly generated 256-bit cryptographically secure string string (`openssl rand -hex 32`). Rotate this periodically.

## 2. API Hardening
- **Restrict CORS Origins**: Currently, CORS allows wildcard domains `["*"]`. Before publishing your backend API link for web access, restrict `allow_origins` in `main.py` to only explicitly permitted Flutter frontend domains. (Mobile app origin headers generally fall under wildcard necessities, but check carefully).
- **Rate-Limiting Application**: FastAPI lacks built-in rate-limiting. Malicious users can spam `/ai/ask` driving up Gemini costs quickly. Recommendation: Install `slowapi` to add endpoint rate-limiting by IP.

## 3. Vulnerability Mitigation
- **Denial of Wallet**: Ensure Gemini API limits are set in the Google Cloud Console to avoid catastrophic billing issues if an API abuse attack occurs.
- **Document Exposure**: Endpoints rely heavily on token matching `(doc.user_id == token_data.get("user_id"))`, which is correctly implemented. Protect the database tightly so unauthorized manual modifications to ownership tables don't occur.

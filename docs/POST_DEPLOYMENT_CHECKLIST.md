# POST-DEPLOYMENT VERIFICATION CHECKLIST - Visionary Lens

Execute these tests immediately after the FastAPI deployment turns "Live" on Render and the APK is compiled.

## 1. Backend Systems Verification
- [ ] Check the logs in Render Dashboard to ensure FastAPI started successfully without syntax or module errors.
- [ ] Verify the `/health` endpoint is returning `{"status": "healthy"}`.
- [ ] Navigate to `<RENDER_URL>/docs` (Swagger UI) to ensure the API is fully discoverable.

## 2. API End-to-End Tests via Swagger UI
- [ ] **Register:** Create a test user via `POST /auth/register`.
- [ ] **Login:** Login with the test user to acquire `access_token` and click "Authorize" in Swagger.
- [ ] **Database & Migrations:** Verify that `users` table correctly saved the test user via Supabase dashboard.

## 3. Storage & AI Verification
- [ ] **Upload:** Upload a test image to `POST /documents/upload`.
- [ ] **Cloudinary Validation:** Ensure the returned `image_url` is a secure Cloudinary URL (`https://res.cloudinary.com/...`).
- [ ] **OCR Execution:** Trigger `POST /ocr/extract` with the `document_id`. Verify Gemini responds with accurate text within 2-4 seconds.

## 4. Flutter Integration Verification
- [ ] Update testing mobile device to use the compiled app pointing to the live Render Backend.
- [ ] Register/Login via the mobile interface with Voice Guide activated.
- [ ] Try creating an "Ask My Notes" request to verify state integration of new AI answers over the web.

## 5. Security Check
- [ ] Attempt to access `GET /documents/{id}` without a token; it must return `403 Forbidden` or `401 Unauthorized`.
- [ ] Guarantee `DATABASE_URL` is completely distinct from the local development DB.

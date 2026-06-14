# RENDER.COM DEPLOYMENT INSTRUCTIONS

Render provides a highly scalable and seamless deployment pipeline for FastAPI backends. Because we included a `render.yaml` infrastructure-as-code file, setting this up is largely automated.

## Steps to Deploy

### 1. Push Code to GitHub
1. Create a private GitHub repository for `Visionary Lens`.
2. Commit your entire codebase including the newly updated files, particularly `render.yaml` and `backend/requirements.txt`.
3. Push to GitHub.

### 2. Connect to Render
1. Go to [Render.com](https://render.com) and sign up with GitHub.
2. Navigate to the **Dashboard**.
3. In the "Blueprints" section (or click "New +" -> "Blueprint"), connect the GitHub repository you just created.
4. Render will automatically detect the `render.yaml` configuration.

### 3. Provide Environment Variables
When Render prompts you for environment values:
1. `GEMINI_API_KEY`: Input your Google AI Studio key securely.
2. `DATABASE_URL`: Add the Supabase connection URL. (Make sure to use the transaction connection pooler mode if needed by Supabase).
3. `CLOUDINARY_URL`: Apply your Cloudinary project URL.

### 4. Deploy and Verify
1. Click **Apply Build**.
2. Render will automatically install dependencies and execute: `uvicorn backend.app.main:app --host 0.0.0.0 --port $PORT`.
3. Watch the continuous integration logs.
4. Once deployed, note down the URL provided (e.g., `https://visionary-lens-backend.onrender.com`).

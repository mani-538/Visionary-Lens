# SUPABASE POSTGRESQL SETUP INSTRUCTIONS

Supabase offers a robust and scalable PostgreSQL database ideal for moving away from local SQLite.

## Database Switch Initialization

### 1. Account Setup
1. Go to [Supabase](https://supabase.com/).
2. Start a new project and select the region geographically closest to your Render server (e.g., Oregon if you used Oregon in `render.yaml`).
3. Save the **secure database password** you generate.

### 2. Extract the Connection String
1. Within your Supabase Dashboard, go to **Settings > Database**.
2. Scroll to the **Connection string** section.
3. Select the **URI** format. Make sure "Use connection pooling" is selected if recommended by Supabase (commonly required for Serverless architectures like Render, standard port `6543`).
4. Replace `[YOUR-PASSWORD]` with the password from step 1.

### 3. Execution
1. Take the complete URI format: `postgresql://postgres.[ref]:[password]@aws-0-[region].pooler.supabase.com:6543/postgres`.
2. Add this as the `DATABASE_URL` environment variable in your `.env` (locally) and in your Render dashboard (production).

### 4. Automatic Table Generation
1. SQLAlchemy via our FastAPI setup (`Base.metadata.create_all(bind=engine)`) will automatically create the `users`, `documents`, `summaries`, and `conversations` tables the first time the app starts successfully.
2. In the Supabase Dashboard, navigate to the **Table Editor** to confirm these tables have generated successfully after your first backend startup.

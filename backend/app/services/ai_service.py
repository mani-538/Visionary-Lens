import os
import google.generativeai as genai
from PIL import Image

# For production, use environment variables
GEMINI_API_KEY = "YOUR_GEMINI_API_KEY"
genai.configure(api_key=GEMINI_API_KEY)

class AIService:
    def __init__(self):
        self.model = genai.GenerativeModel('gemini-1.5-flash')

    async def extract_text_from_image(self, image_path: str) -> str:
        """
        Uses Gemini Vision to extract text from an image.
        """
        if not os.path.exists(image_path):
            raise FileNotFoundError(f"Image not found at {image_path}")

        img = Image.open(image_path)
        
        prompt = """
        Extract all text from this image. 
        Maintain the structure as much as possible (headings, bullet points, etc.).
        Do not include any other commentary.
        """

        response = self.model.generate_content([prompt, img])
        return response.text

    async def analyze_layout(self, image_path: str) -> str:
        """
        Detects layout structure (Titles, Headings, Tables, etc.)
        """
        img = Image.open(image_path)
        prompt = "Analyze the layout of this document and describe it in a structured format (JSON including regions like Title, Body, Footer)."
        response = self.model.generate_content([prompt, img])
        return response.text

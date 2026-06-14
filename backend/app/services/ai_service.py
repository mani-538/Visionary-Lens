import os
import google.generativeai as genai
from PIL import Image
from dotenv import load_dotenv

load_dotenv()

# Use environment variable for the API key
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
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

    async def summarize_text(self, text: str) -> str:
        """
        Summarizes the extracted text.
        """
        prompt = f"Summarize the following educational content in a way that is easy for a visually impaired student to understand:\n\n{text}"
        response = self.model.generate_content(prompt)
        return response.text

    async def explain_diagram(self, image_path: str) -> str:
        """
        Explains a diagram (Biology, Process, Architecture, etc.)
        """
        img = Image.open(image_path)
        prompt = "Explain this diagram in detail. Imagine you are describing it to a blind student. Be very clear and descriptive about and parts and their relationships."
        response = self.model.generate_content([prompt, img])
        return response.text

    async def explain_formula(self, text_or_image: str, is_image: bool = False) -> str:
        """
        Explains mathematical or scientific formulas.
        """
        if is_image:
            img = Image.open(text_or_image)
            prompt = "Identify and explain any mathematical or scientific formulas in this image. Read them out as they would be spoken (e.g. 'E equals m c squared') and explain what they mean."
            response = self.model.generate_content([prompt, img])
        else:
            prompt = f"Explain this formula: {text_or_image}. Provide the spoken version and the meaning of each variable."
            response = self.model.generate_content(prompt)
        return response.text

    async def ask_contextual_question(self, context: str, question: str) -> str:
        """
        Answers a user question based on the provided document context.
        """
        prompt = f"""
        You are an academic assistant for a visually impaired student.
        Based on the following document content, answer the user's question clearly and concisely.
        
        Document Content:
        {context}
        
        Student's Question:
        {question}
        
        Answer:
        """
        response = self.model.generate_content(prompt)
        return response.text

    async def generate_flashcards(self, text: str) -> str:
        """
        Generates flashcards from the text.
        """
        prompt = f"Based on the following content, generate 5-10 flashcards (Question and Answer pairs) for study. Focus on key concepts and definitions:\n\n{text}"
        response = self.model.generate_content(prompt)
        return response.text

    async def generate_quiz(self, text: str) -> str:
        """
        Generates a quiz from the text.
        """
        prompt = f"Based on the following content, generate a multiple-choice quiz with 5 questions. Provide the questions, options, and correct answers clearly marked:\n\n{text}"
        response = self.model.generate_content(prompt)
        return response.text

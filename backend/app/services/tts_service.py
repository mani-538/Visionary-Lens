import os
from gtts import gTTS
import uuid

AUDIO_DIR = "audio"

class TTSService:
    def __init__(self):
        if not os.path.exists(AUDIO_DIR):
            os.makedirs(AUDIO_DIR)

    async def text_to_speech(self, text: str, lang: str = 'en') -> str:
        """
        Converts text to speech and saves it as an mp3 file.
        Returns the path to the generated file.
        """
        filename = f"{uuid.uuid4()}.mp3"
        filepath = os.path.join(AUDIO_DIR, filename)
        
        tts = gTTS(text=text, lang=lang)
        tts.save(filepath)
        
        return filepath

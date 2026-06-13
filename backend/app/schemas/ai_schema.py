from pydantic import BaseModel
from typing import Optional

class AISummarizeRequest(BaseModel):
    document_id: int

class AIExplainRequest(BaseModel):
    document_id: int

class AIResponse(BaseModel):
    document_id: int
    result: str

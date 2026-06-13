from pydantic import BaseModel
from typing import Optional

class AISummarizeRequest(BaseModel):
    document_id: int

class AIExplainRequest(BaseModel):
    document_id: int

class AIAskRequest(BaseModel):
    document_id: int
    question: str

class AIResponse(BaseModel):
    document_id: int
    result: str

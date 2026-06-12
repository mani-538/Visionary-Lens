from pydantic import BaseModel

class OCRExtractRequest(BaseModel):
    document_id: int

class OCRExtractResponse(BaseModel):
    document_id: int
    extracted_text: str

from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI(title="Portfolio API", version="0.1.0")


class GreetRequest(BaseModel):
    name: str


class GreetResponse(BaseModel):
    message: str


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.post("/greet", response_model=GreetResponse)
def greet(payload: GreetRequest) -> GreetResponse:
    return GreetResponse(message=f"Hello, {payload.name}!")

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .config import settings
from .routers import content, math_engine, students, teachers

app = FastAPI(title="SmartMathLab API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.allowed_origins_list,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(students.router)
app.include_router(content.router)
app.include_router(teachers.router)
app.include_router(math_engine.router)


@app.get("/health")
def health():
    return {"status": "ok"}

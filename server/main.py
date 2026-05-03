import fcntl
import os
import time
from collections import deque
from pathlib import Path
from threading import Lock

from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware

_default_clicks = Path(__file__).parent / "clicks.txt"
CLICKS_FILE = Path(os.environ.get("PORTFOLIO_CLICKS_PATH", _default_clicks))
RATE_LIMIT_MAX = 100
RATE_LIMIT_WINDOW_SECONDS = 10

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173"],
    allow_methods=["GET", "POST"],
    allow_headers=["*"],
)

_rate_limit_buckets: dict[str, deque[float]] = {}
_rate_limit_lock = Lock()


def _read_count() -> int:
    if not CLICKS_FILE.exists():
        return 0
    text = CLICKS_FILE.read_text().strip()
    return int(text) if text else 0


def _increment_count() -> int:
    CLICKS_FILE.touch(exist_ok=True)
    with CLICKS_FILE.open("r+") as f:
        fcntl.flock(f.fileno(), fcntl.LOCK_EX)
        try:
            text = f.read().strip()
            count = int(text) if text else 0
            count += 1
            f.seek(0)
            f.truncate()
            f.write(str(count))
            f.flush()
            return count
        finally:
            fcntl.flock(f.fileno(), fcntl.LOCK_UN)


def _check_rate_limit(ip: str) -> None:
    now = time.monotonic()
    cutoff = now - RATE_LIMIT_WINDOW_SECONDS
    with _rate_limit_lock:
        bucket = _rate_limit_buckets.setdefault(ip, deque())
        while bucket and bucket[0] < cutoff:
            bucket.popleft()
        if len(bucket) >= RATE_LIMIT_MAX:
            raise HTTPException(status_code=429, detail="Too many clicks")
        bucket.append(now)


@app.get("/api/clicks")
def get_clicks() -> dict[str, int]:
    return {"count": _read_count()}


@app.post("/api/clicks")
def post_clicks(request: Request) -> dict[str, int]:
    ip = request.client.host if request.client else "unknown"
    _check_rate_limit(ip)
    return {"count": _increment_count()}

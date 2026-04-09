# ─────────────────────────────────────────────
# Stage 1: Build Vue frontend
# ─────────────────────────────────────────────
FROM node:20-slim AS frontend-builder

WORKDIR /frontend

# Install deps (cached layer)
COPY frontend/package.json frontend/package-lock.json ./
RUN npm ci

# Copy source + locales (needed by @locales alias in vite config)
COPY frontend/ ./
COPY locales/ /locales/

# Build static assets
RUN npm run build


# ─────────────────────────────────────────────
# Stage 2: Python runtime (slim, no Node)
# ─────────────────────────────────────────────
FROM python:3.11-slim

# System packages needed by some Python deps (e.g. PyMuPDF)
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
     libmupdf-dev \
     gcc \
  && rm -rf /var/lib/apt/lists/*

# Install uv for fast dependency resolution
COPY --from=ghcr.io/astral-sh/uv:0.9.26 /uv /bin/uv

WORKDIR /app

# Install Python dependencies first (cached layer)
COPY backend/pyproject.toml backend/uv.lock ./backend/
RUN cd backend && uv sync --no-dev

# Copy backend source
COPY backend/ ./backend/
COPY locales/ ./locales/

# Copy built frontend into Flask's static serving path
COPY --from=frontend-builder /frontend/dist ./frontend/dist

# Create uploads directory
RUN mkdir -p backend/uploads

EXPOSE 5001

CMD ["backend/.venv/bin/python", "backend/run.py"]
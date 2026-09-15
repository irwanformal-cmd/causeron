# Causeron — zero-dependency causal prediction engine
# Build:  docker build -t causeron .
# Run:    docker run -p 8000:8000 -v causeron-data:/app/data causeron
# With LLM (optional):
#         docker run -p 8000:8000 -e LLM_API_KEY=... -e LLM_BASE_URL=... \
#                    -e LLM_MODEL_NAME=... -v causeron-data:/app/data causeron
FROM python:3.12-slim

WORKDIR /app

# stdlib only — no pip install step, by design
COPY server.py ./
COPY engine ./engine
COPY static ./static
COPY samples ./samples
COPY kb ./kb
COPY backtests ./backtests
COPY backtest.py ./
COPY test_*.py ./

ENV CAUSERON_HOST=0.0.0.0 \
    CAUSERON_PORT=8000

# projects + llm_config persist here — mount a volume to keep them
VOLUME ["/app/data"]

EXPOSE 8000

# quick self-check, then serve
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD python3 -c "import urllib.request;urllib.request.urlopen('http://127.0.0.1:8000/api/health',timeout=4)"

CMD ["python3", "server.py"]

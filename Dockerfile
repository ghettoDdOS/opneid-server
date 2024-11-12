# syntax=docker/dockerfile:1

ARG PYTHON_VERSION=3.12.7

FROM python:${PYTHON_VERSION}-slim AS base

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    POETRY_HOME=/opt/poetry \
    POETRY_VIRTUALENVS_IN_PROJECT=true

ENV PATH=${POETRY_HOME}/bin:${PATH}

WORKDIR /app

ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update -qy; \
    apt install -qy --no-install-recommends \
    curl; \
    rm -rf /var/lib/apt/lists/*

ARG POETRY_VERSION=1.8.3
RUN curl -sSL https://install.python-poetry.org | \
    POETRY_VERSION=${POETRY_VERSION} python -

RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/root/.cache/pypoetry/artifacts/ \
    --mount=type=cache,target=/root/.cache/pypoetry/cache/ \
    --mount=type=bind,source=poetry.lock,target=poetry.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    poetry install --without dev

USER appuser

COPY . .

EXPOSE 8000

HEALTHCHECK --interval=10s --timeout=5s --retries=5 \
    CMD curl -f http://127.0.0.1:8000/ping || exit 1

CMD ["poetry", "run", "fastapi", "run", "opneid_server/asgi.py"]

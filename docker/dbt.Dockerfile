FROM debian:trixie-slim

ARG USERNAME=dbtadmin
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG VERSION=0.1
ARG build_date=$(date +%Y-%m-%d)

LABEL author="dataengineer24"
LABEL description="Data Build Tool (dbt) and DuckDB"
LABEL version=${VERSION}
LABEL build_date=${build_date}

RUN groupadd --gid ${GROUP_ID} ${USERNAME} && \
    useradd --uid ${USER_ID} --gid ${GROUP_ID} --create-home --shell /bin/bash ${USERNAME}

RUN apt update && \
    apt install -y \
      curl unzip ca-certificates git \
      python3.13 python3.13-venv && \
    rm -rf /var/lib/apt/lists/*

# install uv
COPY --from=ghcr.io/astral-sh/uv:0.12.19 /uv /uvx /bin/

# install duckdb cli
RUN curl -L https://github.com/duckdb/duckdb/releases/latest/download/duckdb_cli-linux-amd64.zip \
    -o /tmp/duckdb.zip && \
    unzip /tmp/duckdb.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/duckdb && \
    rm /tmp/duckdb.zip

WORKDIR /home/${USERNAME}

USER ${USERNAME}

# Keeps Python from buffering stdout and stderr to avoid situations where
# the application crashes without emitting any logs due to buffering.
ENV PYTHONUNBUFFERED=1
# Enable bytecode compilation
ENV UV_COMPILE_BYTECODE=1
# Copy from the cache instead of linking since it's a mounted volume
ENV UV_LINK_MODE=copy
# Omit development dependencies
ENV UV_NO_DEV=1
# Ensure installed tools can be executed out of the box
ENV UV_TOOL_BIN_DIR=/usr/local/bin

# Install the project's dependencies using the lockfile and settings
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --locked --no-install-project

ENV PATH="/home/${USERNAME}/.venv/bin:$PATH"

WORKDIR /home/${USERNAME}/dbt

COPY dbt/ .

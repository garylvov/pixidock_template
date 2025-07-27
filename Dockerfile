# Can try changing devel to base if you don't need to compile anything
ARG BASE_IMAGE=nvidia/cuda:12.6.1-devel-ubuntu22.04
FROM ${BASE_IMAGE}

RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    libgl1 \
    libxcb-cursor0 \
    vim \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://pixi.sh/install.sh | bash
ENV PATH="/root/.pixi/bin:${PATH}"
WORKDIR /workspace
COPY . /workspace/

RUN rm -rf /tmp/* /var/tmp/*

# Use default environment
RUN pixi shell-hook -e default > /workspace/shell-hook.sh
RUN echo 'exec "$@"' >> /workspace/shell-hook.sh
RUN chmod +x /workspace/shell-hook.sh

# For Genesis only
RUN apt-get update && apt install -y libosmesa6 libosmesa6-dev && rm -rf /var/lib/apt/lists/*

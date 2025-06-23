ARG BASE_IMAGE=nvidia/cuda:12.4.1-base-ubuntu22.04
FROM ${BASE_IMAGE}

RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    python3-pip \
    libgl1 \
    libxcb-cursor0 \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://pixi.sh/install.sh | bash
ENV PATH="/root/.pixi/bin:${PATH}"
WORKDIR /workspace
COPY . /workspace/

# Install dependencies
RUN pixi install

RUN rm -rf /tmp/* /var/tmp/*

# Use default environment
RUN pixi shell-hook > /workspace/shell-hook.sh
RUN echo 'exec "$@"' >> /workspace/shell-hook.sh
RUN chmod +x /workspace/shell-hook.sh

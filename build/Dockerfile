# For build automation - Allows building from any ai-dock base image
# MODERNIZED: Default to your new Python 3.12 / CUDA 12.8.1 image
ARG IMAGE_BASE="ghcr.io/phonehomephone/python:v2-cuda-12.8.1-py3.12-22.04"
FROM ${IMAGE_BASE}

# MODERNIZED: Link to your repo
LABEL org.opencontainers.image.source https://github.com/phonehomephone/comfyui
LABEL org.opencontainers.image.description "ComfyUI (Modernized: Py3.12 / CUDA 12.8.1 / PyTorch 2.5.1)"
LABEL maintainer="PhoneHomePhone"

ENV COMFYUI_VENV=$VENV_DIR/comfyui
ENV COMFYUI_VENV_PYTHON=$COMFYUI_VENV/bin/python
ENV COMFYUI_VENV_PIP=$COMFYUI_VENV/bin/pip

ENV API_VENV=$VENV_DIR/api
ENV API_VENV_PYTHON=$API_VENV/bin/python
ENV API_VENV_PIP=$API_VENV/bin/pip

ENV IMAGE_SLUG="comfyui"
ENV OPT_SYNC=ComfyUI

# Prepare environment
# MODERNIZED: Set defaults to Python 3.12
ARG PYTHON_VERSION="3.12"
ENV PYTHON_VERSION=${PYTHON_VERSION}

# MODERNIZED: Upgrade PyTorch to 2.5.1
ARG PYTORCH_VERSION="2.5.1"
ENV PYTORCH_VERSION="${PYTORCH_VERSION}"

COPY --chown=0:1111 ./COPY_ROOT_0/ /
ARG IMAGE_BASE
RUN set -eo pipefail && /opt/ai-dock/bin/build/layer0/init.sh | tee /var/log/build.log

RUN echo "bust cache"
# Install software
ARG COMFYUI_BUILD_REF
ENV COMFYUI_BUILD_REF=${COMFYUI_BUILD_REF}
COPY --chown=0:1111 ./COPY_ROOT_1/ /
RUN set -eo pipefail && /opt/ai-dock/bin/build/layer1/init.sh | tee -a /var/log/build.log

# Copy overrides and models into later layers for fast rebuilds
COPY --chown=0:1111 ./COPY_ROOT_99/ /
RUN set -eo pipefail && /opt/ai-dock/bin/build/layer99/init.sh | tee -a /var/log/build.log
ENV PYTHON_DEFAULT_VENV=comfyui

# Keep init.sh as-is and place additional logic in /opt/ai-dock/bin/preflight.d
CMD ["init.sh"]
# ------------------------------------------------------------------------------
# BASE LAYER
# ------------------------------------------------------------------------------
ARG IMAGE_BASE="ghcr.io/phonehomephone/python:3.12-v2-cuda-12.8.1-devel-22.04"
FROM ${IMAGE_BASE}

LABEL org.opencontainers.image.source https://github.com/phonehomephone/comfyui
LABEL org.opencontainers.image.description "ComfyUI (Modernized: Py3.12 / CUDA 12.8 / Torch 2.5.1 / SageAttn)"
LABEL maintainer="PhoneHomePhone"

# ------------------------------------------------------------------------------
# ENVIRONMENT SETUP
# ------------------------------------------------------------------------------
ENV COMFYUI_VENV=$VENV_DIR/comfyui
ENV COMFYUI_VENV_PYTHON=$COMFYUI_VENV/bin/python
ENV COMFYUI_VENV_PIP=$COMFYUI_VENV/bin/pip
ENV API_VENV=$VENV_DIR/api
ENV API_VENV_PYTHON=$API_VENV/bin/python
ENV API_VENV_PIP=$API_VENV/bin/pip
ENV IMAGE_SLUG="comfyui"
ENV OPT_SYNC=ComfyUI

ARG PYTHON_VERSION="3.12"
ENV PYTHON_VERSION=${PYTHON_VERSION}
ARG PYTORCH_VERSION="2.5.1"
ENV PYTORCH_VERSION="${PYTORCH_VERSION}"
ARG TORCHVISION_VERSION="0.20.1"
ARG TORCHAUDIO_VERSION="2.5.1"

# CRITICAL FIX: FORCE PIP TO USE CUDA 12.4 WHEELS
# The init.sh script defaults to 'cu128' (which is empty/nightly only). 
# We override this to point to the stable 'cu124' repository.
ENV PIP_EXTRA_INDEX_URL="https://download.pytorch.org/whl/cu124"
ENV TORCH_INDEX_URL="https://download.pytorch.org/whl/cu124"

# Copy scripts first
COPY --chown=0:1111 ./COPY_ROOT_0/ /
ARG IMAGE_BASE

# ------------------------------------------------------------------------------
# STEP 1: COMPILERS
# ------------------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc-12 g++-12 git ninja-build \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 100 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-12 100 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------------------------
# STEP 2: PRE-INSTALL PYTORCH & XFORMERS
# ------------------------------------------------------------------------------
# We install these manually to ensure they exist before init.sh runs.
RUN pip install --no-cache-dir \
    torch==${PYTORCH_VERSION} \
    torchvision==${TORCHVISION_VERSION} \
    torchaudio==${TORCHAUDIO_VERSION} \
    xformers \
    --index-url https://download.pytorch.org/whl/cu124

# ------------------------------------------------------------------------------
# STEP 3: INSTALL COMFYUI
# ------------------------------------------------------------------------------
# Now when init.sh runs, it will use our PIP_EXTRA_INDEX_URL 
# and find the packages in the correct repo.
RUN set -eo pipefail && /opt/ai-dock/bin/build/layer0/init.sh | tee /var/log/build.log

# ------------------------------------------------------------------------------
# STEP 4: SAGE ATTENTION (Compiled from Source)
# ------------------------------------------------------------------------------
RUN echo "Compiling SageAttention..." && \
    pip install --no-cache-dir sageattention

# ------------------------------------------------------------------------------
# FINAL LAYERS
# ------------------------------------------------------------------------------
RUN echo "bust cache"
ARG COMFYUI_BUILD_REF
ENV COMFYUI_BUILD_REF=${COMFYUI_BUILD_REF}
COPY --chown=0:1111 ./COPY_ROOT_1/ /
RUN set -eo pipefail && /opt/ai-dock/bin/build/layer1/init.sh | tee -a /var/log/build.log

COPY --chown=0:1111 ./COPY_ROOT_99/ /
RUN set -eo pipefail && /opt/ai-dock/bin/build/layer99/init.sh | tee -a /var/log/build.log
ENV PYTHON_DEFAULT_VENV=comfyui

CMD ["init.sh"]
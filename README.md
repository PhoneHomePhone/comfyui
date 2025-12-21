[![Docker Build](https://github.com/phonehomephone/comfyui/actions/workflows/docker-build.yml/badge.svg)](https://github.com/phonehomephone/comfyui/actions/workflows/docker-build.yml)

# AI-Dock + ComfyUI (Modernized)

Run [ComfyUI](https://github.com/comfyanonymous/ComfyUI) in a highly-configurable, cloud-first AI-Dock container.

> **Modernization Status:**
> * **CUDA:** 12.8.1 (Devel)
> * **PyTorch:** 2.5.1 (Latest Stable)
> * **Python:** 3.12
> * **OS:** Ubuntu 22.04

>[!NOTE]
>These images do not bundle models or third-party configurations. You should use a [provisioning script](https://github.com/ai-dock/base-image/wiki/4.0-Running-the-Image#provisioning-script) to automatically configure your container. You can find examples in `config/provisioning`.

## Documentation

All AI-Dock containers share a common base which is designed to make running on cloud services such as [vast.ai](https://vast.ai) and [runpod.io](https://runpod.io) as straightforward and user friendly as possible.

Common features and options are documented in the [base wiki](https://github.com/ai-dock/base-image/wiki).

## Version Tags

The `:latest` tag points to `:latest-cuda` and provides the most recent stable build of the modern stack.

**Tag Pattern:**
`v2-cuda-[cuda_ver]-pytorch-[torch_ver]-py[python_ver]-[os_ver]`

**Example Tag:**
`:v2-cuda-12.8.1-pytorch-2.5.1-py3.12-22.04`

Browse [GitHub Packages](https://github.com/phonehomephone/comfyui/pkgs/container/comfyui) or [Docker Hub](https://hub.docker.com/u/gitgud5000) for available images.

**Supported Platforms:** `NVIDIA CUDA` (Modern GPUs recommended)

## Additional Environment Variables

| Variable                 | Description |
| ------------------------ | ----------- |
| `AUTO_UPDATE`            | Update ComfyUI on startup (default `false`) |
| `CIVITAI_TOKEN`          | Authenticate download requests from Civitai - Required for gated models |
| `COMFYUI_ARGS`           | Startup arguments. eg. `--gpu-only --highvram` |
| `COMFYUI_PORT_HOST`      | ComfyUI interface port (default `8188`) |
| `COMFYUI_REF`            | Git reference for auto update. Accepts branch, tag or commit hash. Default: latest release |
| `COMFYUI_URL`            | Override `$DIRECT_ADDRESS:port` with URL for ComfyUI |
| `HF_TOKEN`               | Authenticate download requests from HuggingFace - Required for gated models (SD3, FLUX, etc.) |

See the base environment variables [here](https://github.com/ai-dock/base-image/wiki/2.0-Environment-Variables) for more configuration options.

### Additional Python Environments

| Environment    | Packages |
| -------------- | ----------------------------------------- |
| `comfyui`      | ComfyUI and dependencies (Python 3.12 venv) |
| `api`          | ComfyUI API wrapper and dependencies |

The `comfyui` environment will be activated on shell login.

## Additional Services

The following services will be launched alongside the [default services](https://github.com/ai-dock/base-image/wiki/1.0-Included-Software) provided by the base image.

### ComfyUI

The service will launch on port `8188` unless you have
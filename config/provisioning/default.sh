#!/bin/bash

# This file will be sourced in init.sh
# MODERNIZED FOR PYTHON 3.12 + VENV ARCHITECTURE

# Packages are installed after nodes so we can fix them...

#DEFAULT_WORKFLOW="https://..."

APT_PACKAGES=(
    "ffmpeg"
    "libgl1-mesa-glx"
    "libsm6"
    "libxext6"
)

PIP_PACKAGES=(
    "deepdiff"                      # For Crystools node
    "numpy<2"                       # The Anchor
    "colour-science==0.4.4"         # Last version compatible with NumPy 1.x
    "opencv-python-headless<4.10"   # OpenCV 4.9.x (NumPy 1.x compatible)
    "opencv-contrib-python-headless<4.10" # Contrib modules (NumPy 1.x compatible)
    "nvidia-ml-py"
    "pixeloe"                       # Install this last
)

NODES=(
#Qwen-Image-Edit
    "https://github.com/luguoli/ComfyUI-Qwen-Image-Integrated-KSampler.git"
#Upscale
    #"https://github.com/numz/ComfyUI-SeedVR2_VideoUpscaler.git"
    #"https://github.com/ltdrdata/ComfyUI-Manager"
    #"https://github.com/cubiq/ComfyUI_essentials"
    #"https://github.com/ltdrdata/ComfyUI-Impact-Pack"
)

CHECKPOINT_MODELS=(
# -----------------------------------------------------------------------------------
# These files contain EVERYTHING needed to generate an image (Model + CLIP + VAE).
# Use for: SD 1.5, SDXL, Pony, and most standard models.
# Load in ComfyUI with: "Load Checkpoint" node.
# -----------------------------------------------------------------------------------
    #"https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.ckpt"
    #"https://huggingface.co/stabilityai/stable-diffusion-2-1/resolve/main/v2-1_768-ema-pruned.ckpt"
    #"https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors"
    #"https://huggingface.co/stabilityai/stable-diffusion-xl-refiner-1.0/resolve/main/sd_xl_refiner_1.0.safetensors"
    #"https://huggingface.co/Phr00t/Qwen-Image-Edit-Rapid-AIO/resolve/main/v18/Qwen-Rapid-AIO-SFW-v18.safetensors"
)

UNET_MODELS=( 
# -----------------------------------------------------------------------------------
# These files contain ONLY the denoising model. They have no eyes (VAE) or ears (CLIP).
# You MUST load separate CLIP and VAE models to use these.
# Use for: Flux.1, SD 3.5, and GGUF models.
# Load in ComfyUI with: "Load Diffusion Model" (or UNet Loader) node.
# -----------------------------------------------------------------------------------    
)

LORAS_MODELS=(
    #"https://civitai.com/api/download/models/16576"
)

VAE_MODELS=(
    #"https://huggingface.co/stabilityai/sd-vae-ft-ema-original/resolve/main/vae-ft-ema-560000-ema-pruned.safetensors"
    #"https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors"
    #"https://huggingface.co/stabilityai/sdxl-vae/resolve/main/sdxl_vae.safetensors"
)

UPSCALE_MODELS=(
    "https://huggingface.co/ai-forever/Real-ESRGAN/resolve/main/RealESRGAN_x4.pth"
    "https://huggingface.co/FacehugmanIII/4x_foolhardy_Remacri/resolve/main/4x_foolhardy_Remacri.pth"
    "https://huggingface.co/Akumetsu971/SD_Anime_Futuristic_Armor/resolve/main/4x_NMKD-Siax_200k.pth" 

    #"https://huggingface.co/Akumetsu971/SD_Anime_Futuristic_Armor/resolve/main/4x_NMKD-Siax_200k.pth"
)

CONTROLNET_MODELS=(
    #"https://huggingface.co/lllyasviel/sd_control_collection/resolve/main/diffusers_xl_canny_mid.safetensors"
    #"https://huggingface.co/lllyasviel/sd_control_collection/resolve/main/diffusers_xl_depth_mid.safetensors?download"
    #"https://huggingface.co/lllyasviel/sd_control_collection/resolve/main/t2i-adapter_diffusers_xl_openpose.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_canny-fp16.safetensors"
    #"https://huggingface.co/kohya-ss/ControlNet-diff-modules/resolve/main/diff_control_sd15_depth_fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/control_openpose-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_canny-fp16.safetensors"
    #"https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/main/t2iadapter_openpose-fp16.safetensors"

    #"https://huggingface.co/alibaba-pai/Z-Image-Turbo-Fun-Controlnet-Union-2.1/resolve/main/Z-Image-Turbo-Fun-Controlnet-Union-2.0.safetensors"
    #"https://huggingface.co/alibaba-pai/Z-Image-Turbo-Fun-Controlnet-Union-2.1/resolve/main/Z-Image-Turbo-Fun-Controlnet-Tile-2.1-8steps.safetensors"
    #"https://huggingface.co/alibaba-pai/Z-Image-Turbo-Fun-Controlnet-Union-2.1/resolve/main/Z-Image-Turbo-Fun-Controlnet-Union-2.1-8steps.safetensors"
    #"https://huggingface.co/alibaba-pai/Z-Image-Turbo-Fun-Controlnet-Union-2.1/resolve/main/Z-Image-Turbo-Fun-Controlnet-Union-2.1.safetensors" 
)   


### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###

function provisioning_start() {
    # Modern Environment Setup
    source /opt/ai-dock/etc/environment.sh

    # -------------------------------------------------------------------------
    # OPTIONAL: Upgrade PIP to latest version (Silences log warnings)
    # -------------------------------------------------------------------------
    if [[ -n "$COMFYUI_VENV_PIP" ]]; then
        "$COMFYUI_VENV_PIP" install --upgrade pip
    fi

    # -------------------------------------------------------------------------
    # PERSISTENCE: User Data, Outputs, and Inputs
    # -------------------------------------------------------------------------
    # 1. User Settings & Workflows (KEEP THIS ENABLED)
    if [[ ! -d /workspace/storage/comfyui_user ]]; then
        mkdir -p /workspace/storage/comfyui_user
        cp -r /opt/ComfyUI/user/* /workspace/storage/comfyui_user/ 2>/dev/null
    fi
    rm -rf /opt/ComfyUI/user && ln -s /workspace/storage/comfyui_user /opt/ComfyUI/user
    echo "Linked ComfyUI user data to /workspace/storage/comfyui_user"

    # 2. Outputs (Generated Images) - DISABLED TO SAVE DISK SPACE
    # if [[ ! -d /workspace/storage/comfyui_output ]]; then
    #     mkdir -p /workspace/storage/comfyui_output
    # fi
    # rm -rf /opt/ComfyUI/output && ln -s /workspace/storage/comfyui_output /opt/ComfyUI/output

    # 3. Inputs (Uploaded Images) - DISABLED TO SAVE DISK SPACE
    # if [[ ! -d /workspace/storage/comfyui_input ]]; then
    #     mkdir -p /workspace/storage/comfyui_input
    # fi
    # rm -rf /opt/ComfyUI/input && ln -s /workspace/storage/comfyui_input /opt/ComfyUI/input
    
    # -------------------------------------------------------------------------
    # PERSISTENCE: MODEL SYMLINKING
    # -------------------------------------------------------------------------
    declare -A mappings=(
        ["checkpoints"]="/workspace/storage/stable_diffusion/models/checkpoints"
        ["unet"]="/workspace/storage/stable_diffusion/models/unet"
        ["loras"]="/workspace/storage/stable_diffusion/models/loras"
        ["controlnet"]="/workspace/storage/stable_diffusion/models/controlnet"
        ["vae"]="/workspace/storage/stable_diffusion/models/vae"
        ["upscale_models"]="/workspace/storage/stable_diffusion/models/upscale_models"
    )

    for type in "${!mappings[@]}"; do
        src="${mappings[$type]}"
        dest="/opt/ComfyUI/models/$type"
        
        if [[ ! -d "$src" ]]; then mkdir -p "$src"; fi
        
        if [[ -d "$dest" && ! -L "$dest" ]]; then rmdir "$dest" 2>/dev/null || rm -rf "$dest"; fi
        if [[ ! -L "$dest" ]]; then ln -s "$src" "$dest"; fi
        
        printf "Linked %s \t-> %s\n" "$type" "$src"
    done
    # -------------------------------------------------------------------------

    # CLEANUP: Remove Jupyter hidden files
    find ${WORKSPACE}/ComfyUI/custom_nodes -name ".ipynb_checkpoints" -type d -exec rm -rf {} + 2>/dev/null
    find /opt/ComfyUI/custom_nodes -name ".ipynb_checkpoints" -type d -exec rm -rf {} + 2>/dev/null

    provisioning_print_header
    provisioning_get_apt_packages
    provisioning_get_nodes
    provisioning_get_pip_packages
    
    # Downloads
    provisioning_get_models "${mappings[checkpoints]}" "${CHECKPOINT_MODELS[@]}"
    provisioning_get_models "${mappings[unet]}" "${UNET_MODELS[@]}"
    provisioning_get_models "${mappings[loras]}" "${LORAS_MODELS[@]}"
    provisioning_get_models "${mappings[controlnet]}" "${CONTROLNET_MODELS[@]}"
    provisioning_get_models "${mappings[vae]}" "${VAE_MODELS[@]}"
    provisioning_get_models "${mappings[upscale_models]}" "${UPSCALE_MODELS[@]}"
    
    provisioning_print_end
}

function pip_install() {
    # MODERNIZED: Direct PIP usage without Micromamba
    # $COMFYUI_VENV_PIP is defined in the Dockerfile
    if [[ -z "$COMFYUI_VENV_PIP" ]]; then
        echo "Error: COMFYUI_VENV_PIP variable is not set. Falling back to 'pip'"
        pip install --no-cache-dir "$@"
    else
        "$COMFYUI_VENV_PIP" install --no-cache-dir "$@"
    fi
}

function provisioning_get_apt_packages() {
    if [[ -n $APT_PACKAGES ]]; then
            sudo $APT_INSTALL ${APT_PACKAGES[@]}
    fi
}

function provisioning_get_pip_packages() {
    if [[ -n $PIP_PACKAGES ]]; then
            pip_install ${PIP_PACKAGES[@]}
    fi
}

function provisioning_get_nodes() {
    for repo in "${NODES[@]}"; do
        dir="${repo##*/}"
        path="/opt/ComfyUI/custom_nodes/${dir}"
        requirements="${path}/requirements.txt"
        if [[ -d $path ]]; then
            if [[ ${AUTO_UPDATE,,} != "false" ]]; then
                printf "Updating node: %s...\n" "${repo}"
                ( cd "$path" && git pull )
                if [[ -e $requirements ]]; then
                   pip_install -r "$requirements"
                fi
            fi
        else
            printf "Downloading node: %s...\n" "${repo}"
            git clone "${repo}" "${path}" --recursive
            if [[ -e $requirements ]]; then
                pip_install -r "${requirements}"
            fi
        fi
    done
}

function provisioning_get_default_workflow() {
    if [[ -n $DEFAULT_WORKFLOW ]]; then
        workflow_json=$(curl -s "$DEFAULT_WORKFLOW")
        if [[ -n $workflow_json ]]; then
            echo "export const defaultGraph = $workflow_json;" > /opt/ComfyUI/web/scripts/defaultGraph.js
        fi
    fi
}

function provisioning_get_models() {
    if [[ -z $2 ]]; then return 1; fi
    
    dir="$1"
    mkdir -p "$dir"
    shift
    arr=("$@")
    printf "Downloading %s model(s) to %s...\n" "${#arr[@]}" "$dir"
    for url in "${arr[@]}"; do
        printf "Downloading: %s\n" "${url}"
        provisioning_download "${url}" "${dir}"
        printf "\n"
    done
}

function provisioning_print_header() {
    printf "\n##############################################\n#                                            #\n#          Provisioning container            #\n#                                            #\n#         This will take some time           #\n#                                            #\n# Your container will be ready on completion #\n#                                            #\n##############################################\n\n"
    if [[ $DISK_GB_ALLOCATED -lt $DISK_GB_REQUIRED ]]; then
        printf "WARNING: Your allocated disk size (%sGB) is below the recommended %sGB - Some models will not be downloaded\n" "$DISK_GB_ALLOCATED" "$DISK_GB_REQUIRED"
    fi
}

function provisioning_print_end() {
    printf "\nProvisioning complete:  Web UI will start now\n\n"
}

function provisioning_has_valid_hf_token() {
    [[ -n "$HF_TOKEN" ]] || return 1
    url="https://huggingface.co/api/whoami-v2"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $HF_TOKEN" \
        -H "Content-Type: application/json")

    # Check if the token is valid
    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

function provisioning_has_valid_civitai_token() {
    [[ -n "$CIVITAI_TOKEN" ]] || return 1
    url="https://civitai.com/api/v1/models?hidden=1&limit=1"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $CIVITAI_TOKEN" \
        -H "Content-Type: application/json")

    # Check if the token is valid
    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

# Download from $1 URL to $2 file path
function provisioning_download() {
    if [[ -n $HF_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?huggingface\.co(/|$|\?) ]]; then
        auth_token="$HF_TOKEN"
    elif 
        [[ -n $CIVITAI_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?civitai\.com(/|$|\?) ]]; then
        auth_token="$CIVITAI_TOKEN"
    fi
    if [[ -n $auth_token ]];then
        wget --header="Authorization: Bearer $auth_token" -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1"
    else
        wget -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1"
    fi
}

provisioning_start
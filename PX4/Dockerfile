FROM px4io/px4-dev-ros-melodic:latest

# This image requires nvidia-docker on the host as well as docker>=19.03
# https://medium.com/@benjamin.botto/opengl-and-cuda-applications-in-docker-af0eece000f1
# Dependencies for glvnd and X11.
RUN apt-get update \
  && apt-get install -y -qq --no-install-recommends \
    libglvnd0 \
    libgl1 \
    libglx0 \
    libegl1 \
    libxext6 \
    libx11-6 \
  && rm -rf /var/lib/apt/lists/*

# Env vars for the nvidia-container-runtime.
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute
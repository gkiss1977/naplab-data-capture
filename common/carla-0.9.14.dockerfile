ARG CARLA_IMAGE=carlasim/carla:0.9.14
FROM ${CARLA_IMAGE}

USER root
RUN apt-key del 7fa2af80
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub
RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

WORKDIR /home/carla/Import
RUN wget https://carla-releases.s3.eu-west-3.amazonaws.com/Linux/AdditionalMaps_0.9.14.tar.gz
WORKDIR /home/carla
RUN ./ImportAssets.sh

USER carla

CMD ["/bin/bash", "CarlaUE4.sh", "-vulkan", "-RenderOffScreen"]

HEALTHCHECK --interval=1s --timeout=1s --start-period=5s --retries=30 \
    CMD grep -qi ':07d0' /proc/1/net/tcp

# Download, install, and init Vivado
# based on https://github.com/Tosainu/docker-vivado/blob/main/Dockerfile

FROM ubuntu:jammy AS base
ARG INSTALLER_BIN="FPGAs_AdaptiveSoCs_Unified_2024.1_0522_2023_Lin64.bin"
ARG DEBIAN_FRONTEND="noninteractive"
RUN apt-get update && apt-get install -y --no-install-recommends \
  curl expect file libgtk2.0-0 libncurses5 libswt-glx-gtk-4-jni libtinfo5 locales python3 x11-utils xz-utils xvfb
RUN rm -rf /var/lib/apt/lists/* && \
  sed -i 's/^#\s*\(en_US.UTF-8\)/\1/' /etc/locale.gen && \
  dpkg-reconfigure --frontend noninteractive locales

FROM base AS installer-base
COPY --chmod=755 $INSTALLER_BIN /installer.bin
RUN /installer.bin --keep --noexec --target /installer

FROM installer-base AS init-config
RUN /installer/xsetup -b ConfigGen -p 'Vivado' -e 'Vivado ML Standard' -l /opt/Xilinx

# Used to generate base install_config.txt
FROM scratch AS gen-config
COPY --from=init-config /root/.Xilinx/install_config.txt /

FROM installer-base AS install
COPY auth_token_gen.exp /
COPY vivado.env /
COPY install_config.txt /install_config.txt
COPY --chmod=755 $INSTALLER_BIN /installer.bin
SHELL ["/bin/bash", "-c"]
RUN source /vivado.env && \
  expect -f /auth_token_gen.exp /installer/xsetup && \
  /installer/xsetup -b Install -a "XilinxEULA,3rdPartyEULA" -c /install_config.txt && \
  rm -rf /opt/Xilinx/.xinstall /opt/Xilinx/Downloads /opt/Xilinx/xic /vivado.env

FROM base
COPY --from=install /opt/Xilinx /opt/Xilinx
COPY --chmod=755 entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]

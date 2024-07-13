# Vivado in Docker

Download Vivado linux bin - https://www.xilinx.com/member/forms/download/xef.html?filename=FPGAs_AdaptiveSoCs_Unified_2024.1_0522_2023_Lin64.bin
(This requires logging in with AMD)

The following commands assume `vivado-docker/` is the current directory.

```sh
# Generate base install_config.txt
docker build --target gen-config --output type=local,dest=. .

# I also saved an example generated install_config.txt to default_install_config.txt
```

Edit `install_config.txt` modules to minimize image size. To disable modules, set `:1` to `:0`.
Since I'm developing on Artix-7 board, I only enabled the Artix-7 modules.
This reduces the installation size from ~100GB to ~40GB.

Copy `vivado.env.template` to `vivado.env` and set AMD credentials. Also, make sure `vivado.env` is excluded via `.gitignore` !

```sh
# Build Vivado image
docker build -t vivado:v2024.1 .
```

```sh
# Run Vivado in Docker
docker run -it --rm -e "REUID=$UID" -e "REGID=$GID" -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro vivado:v2024.1 \
  /bin/bash -c 'cd && . /opt/Xilinx/Vivado/2024.1/settings64.sh && _JAVA_AWT_WM_NONREPARENTING=1 LD_PRELOAD=/lib/x86_64-linux-gnu/libudev.so.1 vivado'
```

# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /
COPY system_files /system_files

# Base Image - Bazzite Handheld Edition (Legion Go / handheld PCs)
FROM ghcr.io/ublue-os/bazzite-deck:stable

### MODIFICATIONS
## Run custom build script
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh

### REMOVE UNWANTED COMPONENTS
## Remove Lutris and Waydroid while keeping Steam/Gamescope/handheld features
RUN rpm-ostree override remove \
    lutris \
    waydroid \
    waydroid-selinux

### LINTING
## Verify final image and contents are correct
RUN bootc container lint

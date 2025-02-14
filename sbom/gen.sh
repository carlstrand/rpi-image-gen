#!/bin/bash

set -eu

rootfs=$1
outdir=$2

SYFT_VER=v1.19.0

# If host has syft, use it
if ! hash syft 2>/dev/null; then
   curl -sSfL https://raw.githubusercontent.com/anchore/syft/${SYFT_VER}/install.sh \
      | sh -s -- -b ${IGconf_sys_workdir}/host/bin
fi

SYFT=$(syft --version 2>/dev/null) || die "syft is unusable"

msg "SBOM: $SYFT scanning $rootfs"

podman unshare syft scan dir:"$rootfs" \
   --base-path "$rootfs" \
   --source-name "$IGconf_image_name" \
   --source-version "${IGconf_image_version}" \
   --output ${IGconf_sbom_output_format}="${outdir}/${IGconf_image_name}.sbom"

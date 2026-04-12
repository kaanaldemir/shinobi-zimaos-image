#!/bin/bash
set -euo pipefail

ffmpeg_version="$(ffmpeg -hide_banner -version)"
echo "$ffmpeg_version" >/dev/null
if ! grep -q -- '--enable-libvpl' <<< "$ffmpeg_version"; then
  echo "FFmpeg is missing --enable-libvpl"
  exit 1
fi
if grep -q -- '--enable-libmfx' <<< "$ffmpeg_version"; then
  echo "Unexpected libmfx-enabled ffmpeg. Expected libvpl build."
  exit 1
fi
hwaccels="$(ffmpeg -hide_banner -hwaccels)"
encoders="$(ffmpeg -hide_banner -encoders)"
if ! grep -q '^vaapi$' <<< "$hwaccels"; then
  echo "Missing vaapi hwaccel"
  exit 1
fi
if ! grep -q '^qsv$' <<< "$hwaccels"; then
  echo "Missing qsv hwaccel"
  exit 1
fi
for encoder in h264_qsv hevc_qsv h264_vaapi hevc_vaapi; do
  if ! grep -q "$encoder" <<< "$encoders"; then
    echo "Missing encoder $encoder"
    exit 1
  fi
done

dpkg -l | grep -q 'intel-media-va-driver'
dpkg -l | grep -q 'libvpl2'
dpkg -l | grep -q 'vainfo'

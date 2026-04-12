#!/bin/bash
set -euo pipefail

if [ ! -e /dev/dri/renderD128 ]; then
  echo "Missing /dev/dri/renderD128"
  exit 1
fi

vainfo --display drm --device /dev/dri/renderD128

ffmpeg -hide_banner -hwaccels
ffmpeg -hide_banner -encoders | grep -E 'qsv|vaapi'

echo
echo "Static Intel checks passed."
echo "Run a real transcode test against a sample or RTSP input before promoting this image for QSV use."

#!/bin/bash
set -euo pipefail

if [ ! -e /dev/dri/renderD128 ]; then
  echo "Missing /dev/dri/renderD128"
  exit 1
fi

vainfo --display drm --device /dev/dri/renderD128

ffmpeg -hide_banner -version | grep -- '--enable-libvpl'
ffmpeg -hide_banner -hwaccels
ffmpeg -hide_banner -encoders | grep -E 'qsv|vaapi'

echo
echo "Static Intel checks passed."
if [ -n "${TEST_RTSP_URL:-}" ]; then
  ffmpeg -hide_banner -loglevel error \
    -init_hw_device qsv=hw:/dev/dri/renderD128 \
    -filter_hw_device hw \
    -rtsp_transport tcp \
    -i "${TEST_RTSP_URL}" \
    -t "${TEST_DURATION:-3}" \
    -an \
    -vf "vpp_qsv=format=nv12" \
    -c:v h264_qsv \
    -preset veryfast \
    -global_quality 23 \
    -look_ahead 0 \
    -f null -
  echo "QSV runtime transcode passed."
else
  echo "Set TEST_RTSP_URL to run a real QSV transcode check on target hardware."
fi

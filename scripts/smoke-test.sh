#!/bin/bash
set -euo pipefail

ffmpeg -hide_banner -version >/dev/null
ffmpeg -hide_banner -hwaccels | grep -q '^vaapi$'
ffmpeg -hide_banner -hwaccels | grep -q '^qsv$'
ffmpeg -hide_banner -encoders | grep -q 'h264_qsv'
ffmpeg -hide_banner -encoders | grep -q 'hevc_qsv'
ffmpeg -hide_banner -encoders | grep -q 'h264_vaapi'
ffmpeg -hide_banner -encoders | grep -q 'hevc_vaapi'

dpkg -l | grep -q 'intel-media-va-driver'
dpkg -l | grep -q 'libmfx1'
dpkg -l | grep -q 'vainfo'

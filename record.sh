#!/usr/bin/env bash
set -e

ENV_FILE="$1"

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${BASE_DIR}/${ENV_FILE}"

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <ENV_FILE> <CAMERA_NO> <DURATION_SECONDS>"
  echo "Example: $0 1 60"
  exit 1
fi

CAM_NO="$2"
DURATION="$3"

if ! [[ "$CAM_NO" =~ ^[0-9]+$ ]]; then
  echo "Invalid camera number"
  exit 1
fi

if ! [[ "$DURATION" =~ ^[0-9]+$ ]] || [[ "$DURATION" -le 0 ]]; then
  echo "Invalid duration"
  exit 1
fi

# -------------------------------
# Load camera config dynamically
# -------------------------------
eval CAMERA_HOST="\${CAMERA_${CAM_NO}_HOST}"
eval CAMERA_RTSP_PORT="\${CAMERA_${CAM_NO}_RTSP_PORT}"
eval CAMERA_USER="\${CAMERA_${CAM_NO}_USER}"
eval CAMERA_PASS="\${CAMERA_${CAM_NO}_PASS}"
eval CAMERA_PROFILE="\${CAMERA_${CAM_NO}_PROFILE}"
eval CAMERA_PATH="\${CAMERA_${CAM_NO}_PATH}"
eval CAMERA_NAME="\${CAMERA_${CAM_NO}_NAME}"

if [[ -z "$CAMERA_HOST" ]]; then
  echo "Camera $CAM_NO not defined"
  exit 1
fi

# -------------------------------
# URL Encode (password)
# -------------------------------
urlencode() {
  python3 - <<EOF
import urllib.parse
print(urllib.parse.quote("$1"))
EOF
}

ENC_PASS=$(urlencode "$CAMERA_PASS")

RTSP_URL="rtsp://${CAMERA_USER}:${ENC_PASS}@${CAMERA_HOST}:${CAMERA_RTSP_PORT}/${CAMERA_PROFILE}/${CAMERA_PATH}"

# -------------------------------
# Output path
# -------------------------------
DATE=$(date "+%Y%m%d")
TIME=$(date "+%Y%m%d%H%M%S")

OUT_DIR="${RECORD_BASE_DIR}/${CAMERA_NAME}/${DATE}"
mkdir -p "$OUT_DIR"

OUT_FILE="${OUT_DIR}/${CAMERA_NAME}_${TIME}.mp4"

echo "[INFO] CAMERA : ${CAMERA_NAME} (#${CAM_NO})"
echo "[INFO] RTSP   : $RTSP_URL"
echo "[INFO] DUR    : ${DURATION}s"
echo "[INFO] SAVE   : $OUT_FILE"

# -------------------------------
# Record (LIVE)
# -------------------------------
ffmpeg -y \
-rtsp_transport tcp \
-i "$RTSP_URL" \
-t "$DURATION" \
-c copy \
"$OUT_FILE"


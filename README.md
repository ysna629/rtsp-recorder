# RTSP Recorder

FFmpeg 기반 RTSP CCTV 영상 녹화 자동화 스크립트입니다.
환경 파일(.env)을 통해 다중 카메라 설정을 동적으로 로드하고,
지정한 시간 동안 영상을 녹화하여 저장합니다.

---

## 📌 Features

- RTSP 기반 CCTV 영상 녹화
- 다중 카메라 설정 지원 (카메라 번호 기반 선택)
- 환경 파일 기반 설정 관리
- 녹화 시간 지정 가능
- 날짜별 자동 디렉토리 생성
- 패스워드 URL 인코딩 지원
- FFmpeg 스트림 복사 모드(`-c copy`)로 원본 품질 유지

---

## 🛠 Requirements

- Bash
- FFmpeg
- Python3 (URL Encoding용)

설치 확인:

```bash
ffmpeg -version
python3 --version# rtsp-recorder


---
## 📁 Project Structure

rtsp-recorder/
├── record.sh
├── camera.env
└── README.md

---

## ⚙️ Environment File Example

```bash
RECORD_BASE_DIR="/data/recordings"

CAMERA_1_HOST="192.168.0.10"
CAMERA_1_RTSP_PORT="554"
CAMERA_1_USER="admin"
CAMERA_1_PASS="password"
CAMERA_1_PROFILE="profile1"
CAMERA_1_PATH="stream1"
CAMERA_1_NAME="gate_cam"

---

## 🚀 Usage

```bash
./record.sh <ENV_FILE> <CAMERA_NO> <DURATION_SECONDS>

```bash
./record.sh camera.env 1 60

---

## 📂 Output Structure

${RECORD_BASE_DIR}/
 └── CAMERA_NAME/
     └── YYYYMMDD/
         └── CAMERA_NAME_YYYYMMDDHHMMSS.mp4

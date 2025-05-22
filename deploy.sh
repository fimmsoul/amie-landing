#!/bin/bash

# S3 버킷 정보
BUCKET_NAME="landing.amieonline.com"
REGION="ap-northeast-2"
AMPLIFY_APP_ID="djg07jxyb9lj2"
BRANCH_NAME="staging"
DEPLOYMENT_ZIP="deployment.zip"
S3_DEPLOYMENT_PATH="deployments/$DEPLOYMENT_ZIP"
FORCE_MODE=true  # 기존 작업 강제 중지

# 로그 출력용 색상
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 업로드할 파일들 (현재 디렉토리의 모든 파일, .git과 .github 제외)
echo -e "${YELLOW}S3 버킷에 파일 업로드 중...${NC}"
aws s3 sync . s3://$BUCKET_NAME --exclude ".git/*" --exclude ".github/*" --exclude "$DEPLOYMENT_ZIP" --acl public-read

if [ $? -eq 0 ]; then
  echo -e "${GREEN}S3 배포 완료!${NC}"
  echo -e "URL: http://$BUCKET_NAME.s3-website.$REGION.amazonaws.com"
else
  echo -e "${RED}S3 배포 실패!${NC}"
  exit 1
fi

# Amplify 빌드 트리거 (AWS CLI가 설치되어 있고 권한이 있는 경우)
echo -e "${YELLOW}Amplify 배포 준비 중...${NC}"

# 기존 작업 중지 (강제 모드)
if [ "$FORCE_MODE" = true ]; then
  echo -e "${YELLOW}진행 중인 작업이 있는지 확인하는 중...${NC}"
  JOBS=$(aws amplify list-jobs --app-id $AMPLIFY_APP_ID --branch-name $BRANCH_NAME --status "PENDING" "RUNNING" "PROVISIONING" 2>/dev/null)
  
  if [ $? -eq 0 ]; then
    JOB_IDS=$(echo $JOBS | jq -r '.jobSummaries[].jobId' 2>/dev/null)
    
    if [ ! -z "$JOB_IDS" ]; then
      echo -e "${YELLOW}진행 중인 작업을 중지하는 중...${NC}"
      for JOB_ID in $JOB_IDS; do
        echo -e "작업 ID ${JOB_ID} 중지 중..."
        aws amplify stop-job --app-id $AMPLIFY_APP_ID --branch-name $BRANCH_NAME --job-id $JOB_ID
        sleep 2
      done
    fi
  fi
fi

# 파일 압축
echo -e "${YELLOW}파일 압축 중...${NC}"
zip -r $DEPLOYMENT_ZIP . -x "*.git*" "*.github*" "*.zip"

# 압축 파일을 S3에 업로드
echo -e "${YELLOW}배포 파일을 S3에 업로드 중...${NC}"
aws s3 cp $DEPLOYMENT_ZIP s3://$BUCKET_NAME/$S3_DEPLOYMENT_PATH --acl public-read

if [ $? -ne 0 ]; then
  echo -e "${RED}배포 파일 S3 업로드 실패!${NC}"
  rm $DEPLOYMENT_ZIP
  exit 1
fi

# S3 URL 생성
S3_URL="https://$BUCKET_NAME.s3.$REGION.amazonaws.com/$S3_DEPLOYMENT_PATH"
echo -e "${YELLOW}배포 파일 URL: $S3_URL${NC}"

# 배포 생성
echo -e "${YELLOW}Amplify 배포 생성 중...${NC}"
DEPLOYMENT_RESULT=$(aws amplify create-deployment --app-id $AMPLIFY_APP_ID --branch-name $BRANCH_NAME --file-map "{\"/*.html\":\"index.html\",\"/*.css\":\"styles.css\",\"/*.js\":\"script.js\"}" 2>&1)
CREATE_STATUS=$?

if [ $CREATE_STATUS -eq 0 ]; then
  # 배포 ID 추출
  DEPLOYMENT_ID=$(echo $DEPLOYMENT_RESULT | jq -r '.jobId')
  
  if [ -z "$DEPLOYMENT_ID" ] || [ "$DEPLOYMENT_ID" = "null" ]; then
    echo -e "${RED}배포 ID를 가져올 수 없습니다.${NC}"
    echo -e "${YELLOW}응답: $DEPLOYMENT_RESULT${NC}"
    rm -f $DEPLOYMENT_ZIP
    exit 1
  fi
  
  # 배포 파일 업로드 및 시작
  echo -e "${YELLOW}Amplify 배포 시작 중... (jobId: $DEPLOYMENT_ID)${NC}"
  aws amplify start-deployment --app-id $AMPLIFY_APP_ID --branch-name $BRANCH_NAME --job-id $DEPLOYMENT_ID --source-url $S3_URL
  
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}Amplify 배포 트리거 완료!${NC}"
    echo -e "URL: https://staging.landing.amieonline.com"
    # 압축 파일 정리
    rm $DEPLOYMENT_ZIP
  else
    echo -e "${RED}Amplify 배포 시작 실패!${NC}"
  fi
else
  echo -e "${RED}Amplify 배포 생성 실패!${NC}"
  echo -e "${YELLOW}오류: $DEPLOYMENT_RESULT${NC}"
  
  if [[ "$DEPLOYMENT_RESULT" == *"was not finished"* ]]; then
    echo -e "${YELLOW}이미 실행 중인 작업이 있습니다. FORCE_MODE=true로 설정하세요.${NC}"
  fi
fi

# 에러 처리
if [ $? -ne 0 ]; then
  echo -e "${RED}Amplify 배포 트리거 실패! AWS CLI가 설치되어 있고 적절한 권한이 있는지 확인하세요.${NC}"
  echo -e "${YELLOW}필요한 도구 설치:${NC}"
  echo -e "${YELLOW}AWS CLI 설치: brew install awscli${NC}"
  echo -e "${YELLOW}jq 설치: brew install jq${NC}"
  echo -e "${YELLOW}AWS 자격 증명 설정: aws configure${NC}"
  # 압축 파일 정리
  rm -f $DEPLOYMENT_ZIP
fi 
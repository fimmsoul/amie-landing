# Amié UI Prototype

This is a prototype for the Amié dating application UI. It's designed for UI/UX presentation purposes only and doesn't include backend connections or data persistence.

## Features

- Responsive design that mimics the provided mockup
- Interactive elements:
  - Sidebar navigation
  - Toggle switch for auto-matching
  - Clickable buttons 
  - Hover states

## How to View the Prototype

1. Open the `index.html` file in a web browser
2. Interact with the UI elements to see how they respond
3. Resize the browser to see responsive behavior

## Files Included

- `index.html` - Main HTML structure
- `styles.css` - Custom styling
- `script.js` - Interactivity
- `amie-logo.svg` - SVG heart icon

## Notes

- This is a static prototype for UI/UX demonstration only
- No backend functionality is implemented
- The design uses Tailwind CSS for responsive layout and styling

## Interactive Elements

- Click on sidebar menu items to see the active state change
- Toggle the auto-matching switch
- Click "Go to Chatroom" button to see an alert
- Click the "Recharge" button to see an alert
- Click "Log out" to see a confirmation dialog

## Customization

To change colors:
1. Edit the CSS variables in `styles.css`
2. Or modify the Tailwind config in the `index.html` file

```css
/* In styles.css */
:root {
  --primary-color: #FF6C8F;  /* Change this for the main pink color */
  --secondary-color: #6FB6FF; /* Change this for the blue accents */
  /* Other color variables */
}
```

# AMIE 랜딩 페이지 배포 파이프라인

이 저장소는 GitHub Actions를 사용하여 S3와 AWS Amplify에 자동 배포되도록 설정되어 있습니다.

## 배포 방법

`main` 브랜치에 코드를 푸시하면 자동으로 다음 작업이 실행됩니다:
1. S3 버킷 `landing.amieonline.com`에 파일 업로드
2. AWS Amplify 빌드 트리거

## 초기 설정 (처음 한 번만 필요)

### GitHub Secrets 설정

GitHub 저장소에 다음 시크릿을 추가해야 합니다:

1. GitHub 저장소 페이지에서 Settings > Secrets and variables > Actions 로 이동
2. "New repository secret" 버튼 클릭
3. 다음 시크릿 추가:
   - `AWS_ACCESS_KEY_ID`: AWS IAM 사용자의 액세스 키 ID
   - `AWS_SECRET_ACCESS_KEY`: AWS IAM 사용자의 시크릿 액세스 키

### AWS IAM 권한 설정

배포에 사용하는 IAM 사용자는 다음 권한이 필요합니다:
- S3 버킷 업로드 권한
- Amplify 빌드 시작 권한

다음과 같은 IAM 정책을 IAM 사용자에게 연결하세요:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:DeleteObject",
        "s3:PutObjectAcl"
      ],
      "Resource": [
        "arn:aws:s3:::landing.amieonline.com",
        "arn:aws:s3:::landing.amieonline.com/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "amplify:CreateDeployment",
        "amplify:StartDeployment",
        "amplify:ListJobs",
        "amplify:StopJob"
      ],
      "Resource": "arn:aws:amplify:ap-northeast-2:*:apps/djg07jxyb9lj2"
    }
  ]
}
```

> **참고**: 배포 스크립트 변경으로 인해, S3 버킷에 `deployments/` 폴더에 파일을 업로드할 수 있는 권한이 필요합니다. 위 정책의 S3 권한이 이미 이를 포함하고 있습니다. 
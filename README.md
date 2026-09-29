# Spongeclub AI 협업 워크플로 설치 파일

이 폴더는 Claude와 Codex가 Orca 안에서 공통 협업 정책을 사용하도록 설정하는 공유용
패키지입니다. 발표자의 개인 설정이나 비공개 저장소에 의존하지 않습니다.

## 가장 간단한 설치 방법

1. 이 `workflow-kit` 폴더 전체를 내려받습니다.
2. 사용 중인 Claude 또는 Codex 채팅에 `INSTALL_WITH_AI.md`를 첨부합니다.
3. `설치해 줘`라고 요청합니다.
4. AI가 완료 보고를 하면 Claude와 Codex의 새 채팅을 엽니다.

사용자가 터미널 명령을 직접 입력할 필요는 없습니다. 다만 Orca 설치, 계정 로그인,
복수 계정 연결, 2차 인증과 공식 스킬 설치처럼 AI가 대신할 수 없거나 사용자가 직접
확인해야 하는 단계는 [USER_GUIDE.md](USER_GUIDE.md)를 따라야 합니다.

## 포함 파일

- `INSTALL_WITH_AI.md`: AI가 설치·백업·검증을 수행하기 위한 지시서
- `USER_GUIDE.md`: 사람이 직접 해야 하는 설치와 초기 설정 안내
- `files/TEAMWORK.md`: 공용 협업·자동 계정 전환 정책
- `files/AGENTS.md`: Codex 전역 진입점
- `files/CLAUDE.md`: Claude 전역 진입점
- `skills/skill-curator/SKILL.md`: 사용자 스킬을 한 원본에서 관리·검증·배포하기 위한 공유용 스킬
- `scripts/install.ps1`, `scripts/install.sh`: 운영체제별 설치 스크립트
- `scripts/verify.ps1`, `scripts/verify.sh`: 설치 결과 검증 스크립트

예제 프로젝트와 예제 결과물은 포함하지 않습니다.

`skill-curator`는 협업 규칙 설치 스크립트가 자동 설치하지 않습니다. Skills Manager 프로그램과
저장소 연결은 사용자가 먼저 준비한 뒤 [USER_GUIDE.md](USER_GUIDE.md)에 따라 가져옵니다.

## 설치되는 위치

```text
~/.codex/AGENTS.md
~/.codex/TEAMWORK.md
~/.claude/CLAUDE.md
~/.claude/TEAMWORK.md
```

기존 파일의 내용이 다르면 삭제하지 않고 시간 표시가 붙은 `.backup-*` 파일로 먼저
보존합니다. 설치 스크립트는 파일을 복사하므로 이 폴더를 나중에 이동하거나 삭제해도
설치된 규칙은 유지됩니다. 공유 규칙을 업데이트하려면 새 패키지로 설치를 다시 실행합니다.

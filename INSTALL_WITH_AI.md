# AI에게 전달하는 설치 지시서

## AI 에이전트에게

사용자가 이 파일과 `workflow-kit` 폴더를 제공하고 **설치해 줘**라고 요청하면, 이 문서를
설명하거나 요약하는 데서 멈추지 말고 아래 범위의 설치를 직접 수행하십시오.

사용자의 설치 요청은 다음 로컬 파일 작업에 대한 승인입니다.

- 운영체제와 사용자 홈 경로 확인
- 기존 Claude·Codex 전역 규칙의 읽기 전용 검사
- 기존 전역 규칙의 백업
- 이 패키지의 공용 규칙 파일 복사
- 설치 결과 검증

다음 작업에 대한 승인은 포함하지 않습니다.

- 프로그램 설치 또는 제거
- 새 계정 로그인, 로그아웃, 계정 추가·삭제
- 비밀번호, 인증 코드, API 키 또는 쿠키 입력
- 결제와 구독 변경
- Git commit, push 또는 외부 저장소 생성
- 기존 파일이나 백업 삭제

위 작업이 필요하면 자동으로 진행하지 말고 `USER_GUIDE.md`의 해당 절차를 사용자에게
안내하십시오.

## 설치 전 확인

1. 이 파일의 실제 위치를 확인하고 같은 폴더에 다음 파일이 모두 있는지 검사하십시오.
   - `files/TEAMWORK.md`
   - `files/AGENTS.md`
   - `files/CLAUDE.md`
   - `skills/skill-curator/SKILL.md`
   - Windows: `scripts/install.ps1`, `scripts/verify.ps1`
   - macOS/Linux: `scripts/install.sh`, `scripts/verify.sh`
   - `USER_GUIDE.md`
2. 운영체제와 사용자 홈 경로를 확인하십시오.
3. 기존 대상 파일이 있다면 내용, 파일 종류와 백업 가능 여부를 확인하되 비밀정보를 출력하지 마십시오.
4. 패키지 파일이 없거나 경로가 불명확하면 임의의 내용을 새로 만들지 말고 누락 파일을 보고하십시오.

## 설치 실행

### Windows

패키지 루트에서 다음 스크립트를 프로세스 범위 실행 정책 우회로 실행하십시오.

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\scripts\install.ps1"
```

### macOS

패키지 루트에서 다음 스크립트를 실행하십시오.

```bash
bash ./scripts/install.sh
```

스크립트는 다음 파일을 설치합니다.

```text
~/.codex/AGENTS.md
~/.codex/TEAMWORK.md
~/.claude/CLAUDE.md
~/.claude/TEAMWORK.md
```

대상 파일이 이미 있고 공유본과 다르면 먼저 같은 디렉터리에 시간 표시가 붙은
`.backup-*` 파일을 만든 뒤 복사합니다. 기존 파일이나 백업은 삭제하지 마십시오.

## 설치 검증

설치 직후 운영체제에 맞는 검증 스크립트를 실행하십시오.

Windows:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\scripts\verify.ps1"
```

macOS:

```bash
bash ./scripts/verify.sh
```

검증 스크립트가 실패하면 성공으로 보고하지 마십시오. 원본과 대상 경로, 실패한 검사와
복구 가능한 백업 위치만 보고하고 비밀정보나 파일 전체 내용은 출력하지 마십시오.

파일 검증을 통과한 뒤 현재 환경에서 Orca 공식 `orchestration`, `orca-cli`,
`computer-use` 스킬을 사용할 수 있는지 확인하십시오. 공식 기능이 없거나 프로그램 설치,
로그인 또는 앱 화면 설정이 필요하면 대신 설치하려고 추측하지 말고 `USER_GUIDE.md`에서
사람이 해야 할 항목을 알려 주십시오.

`skills/skill-curator/SKILL.md`는 공유 파일이지만 이 설치 스크립트의 자동 복사 대상이 아닙니다.
Skills Manager가 이미 설치·연결돼 있더라도 기존 동명 스킬을 임의로 덮어쓰지 말고,
`USER_GUIDE.md`의 비교·가져오기 절차를 안내하십시오.

## 완료 보고

다음 형식으로 간결하게 보고하십시오.

```text
운영체제:
설치한 파일:
백업한 파일:
파일 검증: 통과 / 실패
Orca 공식 스킬 확인:
사람이 직접 해야 할 작업:
적용 시점: Claude와 Codex의 새 세션부터
남은 문제:
```

현재 실행 중인 Claude·Codex 세션에는 새 전역 규칙이 다시 로드되지 않을 수 있습니다.
설치가 끝나면 사용자가 새 채팅을 열어야 한다는 점을 반드시 안내하십시오.

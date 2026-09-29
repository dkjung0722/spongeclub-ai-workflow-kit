# Claude 협업 규칙 진입점

한 명의 에이전트가 직접 끝낼 수 있는 일반 작업에서는 `TEAMWORK.md`를 읽지 않습니다.

사용자가 여러 에이전트·위임·병렬 작업을 요청했거나 독립된 보조 작업자가 실질적으로
필요한 경우에만 사용자 홈의 `.claude/TEAMWORK.md`를 읽고 따릅니다. 현재 프로젝트에서
`TEAMWORK.md`를 찾지 않습니다. 감독하는 협업은 Orca 공식 `orchestration` 스킬로
실행하고, 감독 없이 완전히 넘기는 작업은 `orca-cli`의 handoff를 사용합니다.

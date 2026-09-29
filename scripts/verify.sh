#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
package_dir="$(dirname -- "$script_dir")"
files_dir="$package_dir/files"
target_home="${1:-$HOME}"

names=(
  'Codex 진입점'
  'Codex 협업 정책'
  'Claude 진입점'
  'Claude 협업 정책'
)

sources=(
  "$files_dir/AGENTS.md"
  "$files_dir/TEAMWORK.md"
  "$files_dir/CLAUDE.md"
  "$files_dir/TEAMWORK.md"
)

targets=(
  "$target_home/.codex/AGENTS.md"
  "$target_home/.codex/TEAMWORK.md"
  "$target_home/.claude/CLAUDE.md"
  "$target_home/.claude/TEAMWORK.md"
)

failed=0

for index in "${!sources[@]}"; do
  source_file="${sources[$index]}"
  target_file="${targets[$index]}"
  if [[ ! -f "$source_file" ]]; then
    echo "실패: 패키지 원본 없음 - $source_file"
    failed=1
    continue
  fi
  if [[ ! -f "$target_file" ]]; then
    echo "실패: 설치 파일 없음 - $target_file"
    failed=1
    continue
  fi
  if cmp -s -- "$source_file" "$target_file"; then
    echo "통과: ${names[$index]}"
  else
    echo "실패: 내용 불일치 - ${names[$index]}"
    failed=1
  fi
done

if [[ -f "$target_home/.codex/AGENTS.md" ]] && ! grep -Fq '.codex/TEAMWORK.md' "$target_home/.codex/AGENTS.md"; then
  echo '실패: Codex 진입점의 전역 TEAMWORK 경로 누락'
  failed=1
fi
if [[ -f "$target_home/.claude/CLAUDE.md" ]] && ! grep -Fq '.claude/TEAMWORK.md' "$target_home/.claude/CLAUDE.md"; then
  echo '실패: Claude 진입점의 전역 TEAMWORK 경로 누락'
  failed=1
fi
if [[ -f "$target_home/.codex/TEAMWORK.md" ]] && ! grep -Fq 'policy-id: codex-account-auto-switch-v1' "$target_home/.codex/TEAMWORK.md"; then
  echo '실패: 계정 자동 전환 정책 누락'
  failed=1
fi

if (( failed != 0 )); then
  echo '검증 실패'
  exit 1
fi

echo '파일 설치 검증 통과'
echo '공식 orchestration, orca-cli, computer-use 스킬은 현재 Orca 환경에서 별도로 확인하십시오.'
echo '새 Claude와 Codex 세션부터 규칙이 적용됩니다.'

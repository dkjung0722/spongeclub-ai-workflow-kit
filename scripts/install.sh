#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
package_dir="$(dirname -- "$script_dir")"
files_dir="$package_dir/files"
target_home="${1:-$HOME}"
timestamp="$(date -u +%Y%m%d-%H%M%S)"

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

for source_file in "${sources[@]}"; do
  if [[ ! -f "$source_file" ]]; then
    echo "공유 패키지 파일을 찾을 수 없습니다: $source_file" >&2
    exit 1
  fi
done

installed=()
unchanged=()
backups=()

for index in "${!sources[@]}"; do
  source_file="${sources[$index]}"
  target_file="${targets[$index]}"
  mkdir -p -- "$(dirname -- "$target_file")"

  if [[ -d "$target_file" && ! -L "$target_file" ]]; then
    echo "설치 대상이 파일이 아니라 디렉터리입니다: $target_file" >&2
    exit 1
  fi

  if [[ -e "$target_file" || -L "$target_file" ]]; then
    if cmp -s -- "$source_file" "$target_file"; then
      unchanged+=("$target_file")
      continue
    fi

    backup_file="$target_file.backup-$timestamp"
    if [[ -L "$target_file" ]]; then
      mv -- "$target_file" "$backup_file"
    else
      cp -p -- "$target_file" "$backup_file"
    fi
    backups+=("$backup_file")
  fi

  cp -- "$source_file" "$target_file"
  installed+=("$target_file")
done

echo 'AI 협업 규칙 설치 완료'
echo "사용자 홈: $target_home"

if (( ${#installed[@]} > 0 )); then
  echo '설치한 파일:'
  printf '  %s\n' "${installed[@]}"
fi
if (( ${#unchanged[@]} > 0 )); then
  echo '이미 최신 상태인 파일:'
  printf '  %s\n' "${unchanged[@]}"
fi
if (( ${#backups[@]} > 0 )); then
  echo '백업한 파일:'
  printf '  %s\n' "${backups[@]}"
fi

echo 'Claude와 Codex의 새 세션부터 적용됩니다.'

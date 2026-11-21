#!/bin/bash
set -e
set -u

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

mkdir -p "$work/bin"
export OMARCHY_LOG="$work/omarchy.log"

cat > "$work/bin/omarchy-pkg-add" <<'STUB'
#!/bin/bash
echo "pkg:$1" >> "$OMARCHY_LOG"
case " ${MOCK_FAIL_PKG:-} " in
  *" $1 "*) exit 1 ;;
esac
STUB
cat > "$work/bin/omarchy-install-gaming-steam" <<'STUB'
#!/bin/bash
echo "steam" >> "$OMARCHY_LOG"
STUB
cat > "$work/bin/omarchy-install-dictation-voxtype" <<'STUB'
#!/bin/bash
echo "voxtype" >> "$OMARCHY_LOG"
[[ "${MOCK_VOXTYPE_FAIL:-0}" != 1 ]]
STUB
cat > "$work/bin/uname" <<'STUB'
#!/bin/bash
echo "${MOCK_ARCH:-x86_64}"
STUB
chmod +x "$work/bin/"*

export PATH="$work/bin:/usr/bin:/bin"

assert_line() {
  if ! grep -Fxq -- "$1" "$OMARCHY_LOG"; then
    echo "Expected '$1' in the install log" >&2
    cat "$OMARCHY_LOG" >&2
    exit 1
  fi
}

assert_no_line() {
  if grep -Fxq -- "$1" "$OMARCHY_LOG"; then
    echo "Unexpected '$1' in the install log" >&2
    exit 1
  fi
}

run_menu() {
  : > "$OMARCHY_LOG"
  printf '%s\n' "$1" | bash "$script_dir/install.sh" > "$work/output" 2>&1
}

run_menu 1
assert_line 'pkg:helium-browser-bin'
assert_line 'pkg:claude-desktop'
assert_no_line 'pkg:proton-vpn-gtk-app'
assert_no_line 'steam'
assert_no_line 'voxtype'

run_menu 2
assert_line 'pkg:proton-vpn-gtk-app'
assert_line 'pkg:discord'
assert_line 'steam'
assert_no_line 'voxtype'

MOCK_ARCH=aarch64 run_menu 2
assert_line 'pkg:proton-vpn-gtk-app'
assert_no_line 'pkg:discord'
assert_line 'steam'

run_menu 3
assert_line 'voxtype'
assert_no_line 'pkg:helium-browser-bin'
assert_no_line 'steam'

run_menu 4
assert_line 'pkg:helium-browser-bin'
assert_line 'pkg:proton-vpn-gtk-app'
assert_line 'steam'
assert_line 'voxtype'

run_menu 4
if grep -qi 'microsoft\|office\|teams\|onedrive' "$OMARCHY_LOG"; then
  echo "Microsoft 365 packages must not be installed on Omarchy" >&2
  exit 1
fi

run_menu 0
[[ ! -s "$OMARCHY_LOG" ]]

printf '9\n0\n' | bash "$script_dir/install.sh" > "$work/output" 2>&1
[[ ! -s "$OMARCHY_LOG" ]]

: > "$OMARCHY_LOG"
if printf '9\n' | bash "$script_dir/install.sh" > "$work/output" 2>&1; then
  echo "Setup succeeded without a menu selection" >&2
  exit 1
fi
[[ ! -s "$OMARCHY_LOG" ]]

: > "$OMARCHY_LOG"
if printf '1\n' | MOCK_FAIL_PKG=obsidian bash "$script_dir/install.sh" > "$work/output" 2>&1; then
  echo "Light succeeded after obsidian failed to install" >&2
  exit 1
fi
assert_line 'pkg:vlc'
grep -q 'obsidian' "$work/output"

: > "$OMARCHY_LOG"
if printf '3\n' | MOCK_VOXTYPE_FAIL=1 bash "$script_dir/install.sh" > "$work/output" 2>&1; then
  echo "Dictation setup succeeded after Voxtype failed" >&2
  exit 1
fi
grep -q 'voxtype dictation' "$work/output"

rm -f "$work/bin/omarchy-pkg-add"
: > "$OMARCHY_LOG"
if printf '1\n' | bash "$script_dir/install.sh" > "$work/output" 2>&1; then
  echo "The script ran without Omarchy commands" >&2
  exit 1
fi
grep -q 'must run on an installed Omarchy' "$work/output"

echo "Omarchy installer tests passed."

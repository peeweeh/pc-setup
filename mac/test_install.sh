#!/bin/bash
set -e
set -u

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
work="$(mktemp -d)"

cleanup() {
  rm -f "$work/menu/install.sh" "$work/menu/brew_install.sh" "$work/menu/mac_optimize.sh" \
    "$work/bin/brew" "$work/bin/curl" "$work/bin/osascript" "$work/bin/pkgutil" \
    "$work/bin/sudo" "$work/bin/spctl" "$work/bin/uname" "$work/bin/sw_vers" \
    "$work/home/.local/bin/hermes" "$work/home/.zshrc" "$work/home/.zshrc.bak" \
    "$work/home/Library/Fonts/FiraCodeNerdFontMono-Regular.ttf" \
    "$work/home/Library/Fonts/HackNerdFontMono-Regular.ttf" \
    "$work/brew_fixture.sh" "$work/menu.log" "$work/brew.log" "$work/sudo.log" "$work/hermes.log" \
    "$work/output" "$work/yogurt.dmg"
  rmdir "$work/home/Applications/Microsoft Word.app" \
    "$work/home/Applications/Microsoft Excel.app" \
    "$work/home/Applications/Microsoft PowerPoint.app" \
    "$work/home/Applications/Microsoft Outlook.app" \
    "$work/home/Applications" "$work/home/Library/Fonts" "$work/home/Library/LaunchAgents" \
    "$work/home/Library" "$work/home/.local/bin" "$work/home/.local" \
    "$work/home/.hermes/hermes-agent/.git" "$work/home/.hermes/hermes-agent" \
    "$work/home/.hermes" \
    "$work/home/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" \
    "$work/home/.oh-my-zsh/custom/plugins/zsh-autosuggestions" \
    "$work/home/.oh-my-zsh/custom/plugins" "$work/home/.oh-my-zsh/custom" \
    "$work/home/.oh-my-zsh" "$work/home" "$work/menu" "$work/bin" "$work" 2>/dev/null || true
}
trap cleanup EXIT

mkdir -p "$work/menu" "$work/bin" "$work/home/Library/Fonts" "$work/home/Library/LaunchAgents" \
  "$work/home/.local/bin" "$work/home/.hermes/hermes-agent/.git" \
  "$work/home/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" \
  "$work/home/.oh-my-zsh/custom/plugins/zsh-autosuggestions" \
  "$work/home/Applications/Microsoft Word.app" "$work/home/Applications/Microsoft Excel.app" \
  "$work/home/Applications/Microsoft PowerPoint.app" "$work/home/Applications/Microsoft Outlook.app"
cp "$script_dir/install.sh" "$work/menu/install.sh"
sed 's|target="/Applications/Microsoft |target="$HOME/Applications/Microsoft |' \
  "$script_dir/brew_install.sh" > "$work/brew_fixture.sh"
printf 'source powerlevel10k.zsh-theme\nalias ls='\''eza --icons always'\''\n' > "$work/home/.zshrc"
: > "$work/home/Library/Fonts/FiraCodeNerdFontMono-Regular.ttf"
: > "$work/home/Library/Fonts/HackNerdFontMono-Regular.ttf"
printf 'test yogurt archive\n' > "$work/yogurt.dmg"

export HOME="$work/home" PATH="$work/bin:/usr/bin:/bin:/usr/sbin:/sbin" TERM=xterm
export MENU_LOG="$work/menu.log" BREW_LOG="$work/brew.log" SUDO_LOG="$work/sudo.log"
export HERMES_LOG="$work/hermes.log"
export MENU_DIR="$work/menu" YOGURT_CACHE="$work/yogurt.dmg" SUDO_ASKPASS="$work/askpass"
YOGURT_DIGEST="$(shasum -a 256 "$YOGURT_CACHE")"
export YOGURT_DIGEST="${YOGURT_DIGEST%% *}"

cat > "$work/menu/brew_install.sh" <<'STUB'
#!/bin/bash
echo "brew:$*" >> "$MENU_LOG"
exit "${MOCK_BREW_EXIT:-0}"
STUB
cat > "$work/menu/mac_optimize.sh" <<'STUB'
#!/bin/bash
echo "optimize" >> "$MENU_LOG"
exit "${MOCK_OPTIMIZE_EXIT:-0}"
STUB
cat > "$work/home/.local/bin/hermes" <<'STUB'
#!/bin/bash
echo "Hermes test launcher"
STUB
chmod +x "$work/home/.local/bin/hermes"
cat > "$work/bin/brew" <<'STUB'
#!/bin/bash
echo "$*" >> "$BREW_LOG"
case "$1" in
  list)
    if [[ "${2:-}" == --cask && "${3:-}" == frigadehq/yogurt/yogurt &&
          "${MOCK_YOGURT_MISSING:-0}" == 1 ]]; then exit 1; fi
    ;;
  --prefix) echo "$HOME/.brew" ;;
  --cache) echo "$YOGURT_CACHE" ;;
esac
STUB
cat > "$work/bin/curl" <<'STUB'
#!/bin/bash
url="" destination=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    http*) url="$1" ;;
    -o) shift; destination="$1" ;;
  esac
  shift
done
case "$url" in
  *raw.githubusercontent.com*/brew_install.sh)
    [[ "${MOCK_FETCH_FAIL:-0}" != 1 ]] || exit 1
    cp "$MENU_DIR/brew_install.sh" "$destination"
    ;;
  *raw.githubusercontent.com*/mac_optimize.sh)
    cp "$MENU_DIR/mac_optimize.sh" "$destination"
    ;;
  *api.github.com/repos/FrigadeHQ/yogurt/releases/latest)
    printf '{"assets":[{"name":"Yogurt-mac-arm64.dmg","digest":"sha256:%s"}]}\n' "$YOGURT_DIGEST"
    ;;
  *go.microsoft.com*)
    : > "$destination"
    ;;
  *hermes-agent.nousresearch.com/install.sh)
    cat > "$destination" <<'HERMES'
#!/bin/bash
echo "$*" >> "$HERMES_LOG"
mkdir -p "$HOME/.local/bin" "$HOME/.hermes/hermes-agent/.git"
cat > "$HOME/.local/bin/hermes" <<'LAUNCHER'
#!/bin/bash
echo "Hermes test launcher"
LAUNCHER
chmod +x "$HOME/.local/bin/hermes"
HERMES
    ;;
  *) echo "Unexpected download: $url" >&2; exit 1 ;;
esac
STUB
cat > "$work/bin/osascript" <<'STUB'
#!/bin/bash
if [[ "${1:-}" == -l ]]; then
  cat >/dev/null
  [[ "${MOCK_FONT_FAIL:-0}" != 1 ]] || exit 1
fi
exit 0
STUB
cat > "$work/bin/pkgutil" <<'STUB'
#!/bin/bash
if [[ "${MOCK_BAD_SIGNATURE:-0}" == 1 ]]; then
  echo "Developer ID Installer: Untrusted"
else
  echo "Developer ID Installer: Microsoft Corporation (UBF8T346G9)"
fi
STUB
cat > "$work/bin/spctl" <<'STUB'
#!/bin/bash
[[ "${MOCK_ASSESS_FAIL:-0}" != 1 ]]
STUB
cat > "$work/bin/sudo" <<'STUB'
#!/bin/bash
echo "$*" >> "$SUDO_LOG"
case "$*" in
  *Microsoft-Word.pkg*) mkdir -p "$HOME/Applications/Microsoft Word.app" ;;
  *) exit 1 ;;
esac
STUB
cat > "$work/bin/uname" <<'STUB'
#!/bin/bash
echo arm64
STUB
cat > "$work/bin/sw_vers" <<'STUB'
#!/bin/bash
echo 27.2
STUB
chmod +x "$work/bin/"*

assert_line() {
  if ! grep -Fxq -- "$1" "$2"; then
    echo "Expected '$1' in $2" >&2
    exit 1
  fi
}

assert_no_line() {
  if grep -Fxq -- "$1" "$2"; then
    echo "Unexpected '$1' in $2" >&2
    exit 1
  fi
}

: > "$MENU_LOG"
printf '1\n' | /bin/bash "$work/menu/install.sh" > "$work/output"
assert_line 'brew:light' "$MENU_LOG"
assert_no_line 'optimize' "$MENU_LOG"

: > "$MENU_LOG"
printf '2\n' | /bin/bash "$work/menu/install.sh" > "$work/output"
assert_line 'brew:heavy' "$MENU_LOG"
assert_no_line 'optimize' "$MENU_LOG"

: > "$MENU_LOG"
printf '3\ny\n' | /bin/bash "$work/menu/install.sh" > "$work/output"
assert_line 'optimize' "$MENU_LOG"
assert_no_line 'brew:heavy' "$MENU_LOG"

: > "$MENU_LOG"
printf '3\nn\n' | /bin/bash "$work/menu/install.sh" > "$work/output"
[[ ! -s "$MENU_LOG" ]]

: > "$MENU_LOG"
printf '4\ny\n' | /bin/bash "$work/menu/install.sh" > "$work/output"
[[ "$(cat "$MENU_LOG")" == $'brew:heavy\noptimize' ]]

: > "$MENU_LOG"
printf '4\nn\n' | /bin/bash "$work/menu/install.sh" > "$work/output"
[[ ! -s "$MENU_LOG" ]]

: > "$MENU_LOG"
if printf '4\ny\n' | MOCK_BREW_EXIT=1 /bin/bash "$work/menu/install.sh" > "$work/output"; then
  echo "Install ALL succeeded after an app installation failure" >&2
  exit 1
fi
assert_line 'brew:heavy' "$MENU_LOG"
assert_no_line 'optimize' "$MENU_LOG"

: > "$MENU_LOG"
if printf '4\ny\n' | MOCK_OPTIMIZE_EXIT=1 /bin/bash "$work/menu/install.sh" > "$work/output"; then
  echo "Install ALL succeeded after an optimization failure" >&2
  exit 1
fi
[[ "$(cat "$MENU_LOG")" == $'brew:heavy\noptimize' ]]

: > "$MENU_LOG"
printf '2\n' | /bin/bash <(cat "$work/menu/install.sh") > "$work/output"
assert_line 'brew:heavy' "$MENU_LOG"

: > "$MENU_LOG"
if printf '1\n' | MOCK_FETCH_FAIL=1 /bin/bash <(cat "$work/menu/install.sh") > "$work/output"; then
  echo "Remote installer succeeded after a download failure" >&2
  exit 1
fi
assert_no_line 'brew:light' "$MENU_LOG"

: > "$BREW_LOG"
/bin/bash "$work/brew_fixture.sh" light > "$work/output"
assert_line 'list --cask helium-browser' "$BREW_LOG"
assert_line 'list --cask claude' "$BREW_LOG"
assert_line 'list --cask comet' "$BREW_LOG"
assert_line 'list --cask perplexity' "$BREW_LOG"
assert_no_line 'list --cask arc' "$BREW_LOG"
assert_line 'list --cask task-manager-tmog' "$BREW_LOG"
assert_line 'list --formula actionlint' "$BREW_LOG"
assert_line 'list --formula aws-c-s3' "$BREW_LOG"
assert_line 'list --formula bash' "$BREW_LOG"
assert_line 'list --formula coreutils' "$BREW_LOG"
assert_line 'list --formula fontconfig' "$BREW_LOG"
assert_line 'list --formula libheif' "$BREW_LOG"
assert_line 'list --formula openssl@4' "$BREW_LOG"
assert_line 'list --formula python@3.14' "$BREW_LOG"
assert_line 'list --formula python@3.15' "$BREW_LOG"
assert_line 'list --formula ripgrep' "$BREW_LOG"
assert_line 'list --formula shellcheck' "$BREW_LOG"
assert_line 'list --formula tailscale' "$BREW_LOG"
assert_line 'list --formula tirith' "$BREW_LOG"
assert_no_line 'list --cask docker-desktop' "$BREW_LOG"
assert_no_line 'list --cask frigadehq/yogurt/yogurt' "$BREW_LOG"

: > "$BREW_LOG"
/bin/bash "$work/brew_fixture.sh" heavy > "$work/output"
assert_line 'list --cask helium-browser' "$BREW_LOG"
assert_line 'list --cask claude' "$BREW_LOG"
assert_line 'list --cask comet' "$BREW_LOG"
assert_line 'list --cask perplexity' "$BREW_LOG"
assert_no_line 'list --cask arc' "$BREW_LOG"
assert_line 'list --cask docker-desktop' "$BREW_LOG"
assert_line 'list --cask frigadehq/yogurt/yogurt' "$BREW_LOG"
assert_line 'list --cask windows-app' "$BREW_LOG"

: > "$BREW_LOG"
if /bin/bash "$work/brew_fixture.sh" invalid > "$work/output"; then
  echo "An invalid application tier was accepted" >&2
  exit 1
fi
[[ ! -s "$BREW_LOG" ]]

if MOCK_FONT_FAIL=1 /bin/bash "$work/brew_fixture.sh" light > "$work/output"; then
  echo "A failed font registration was reported as successful" >&2
  exit 1
fi
grep -q 'Nerd Font registration' "$work/output"

chmod -x "$HOME/.local/bin/hermes"
if /bin/bash "$work/brew_fixture.sh" light > "$work/output"; then
  echo "A broken Hermes installation was reported as successful" >&2
  exit 1
fi
grep -q 'manual attention' "$work/output"
chmod +x "$HOME/.local/bin/hermes"

rm -f "$HOME/.local/bin/hermes"
rmdir "$HOME/.hermes/hermes-agent/.git" "$HOME/.hermes/hermes-agent"
: > "$HERMES_LOG"
/bin/bash "$work/brew_fixture.sh" light > "$work/output"
assert_line '--non-interactive' "$HERMES_LOG"
[[ -x "$HOME/.local/bin/hermes" ]]

rmdir "$HOME/Applications/Microsoft Word.app"
: > "$SUDO_LOG"
if MOCK_BAD_SIGNATURE=1 /bin/bash "$work/brew_fixture.sh" heavy > "$work/output"; then
  echo "An untrusted Office installer was accepted" >&2
  exit 1
fi
[[ ! -s "$SUDO_LOG" ]]
grep -q 'Microsoft Word' "$work/output"

if MOCK_ASSESS_FAIL=1 /bin/bash "$work/brew_fixture.sh" heavy > "$work/output"; then
  echo "An Office installer rejected by Gatekeeper was accepted" >&2
  exit 1
fi
[[ ! -s "$SUDO_LOG" ]]

/bin/bash "$work/brew_fixture.sh" heavy > "$work/output"
grep -q -- '-A /usr/sbin/installer' "$SUDO_LOG"
[[ -d "$HOME/Applications/Microsoft Word.app" ]]

: > "$BREW_LOG"
if MOCK_YOGURT_MISSING=1 YOGURT_DIGEST=0000000000000000000000000000000000000000000000000000000000000000 \
    /bin/bash "$work/brew_fixture.sh" heavy > "$work/output"; then
  echo "A Yogurt download with the wrong checksum was accepted" >&2
  exit 1
fi
assert_no_line 'install --cask frigadehq/yogurt/yogurt' "$BREW_LOG"

: > "$BREW_LOG"
MOCK_YOGURT_MISSING=1 /bin/bash "$work/brew_fixture.sh" heavy > "$work/output"
assert_line 'trust --cask frigadehq/yogurt/yogurt' "$BREW_LOG"
assert_line 'install --cask frigadehq/yogurt/yogurt' "$BREW_LOG"

echo "macOS installer tests passed."

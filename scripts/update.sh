#!/usr/bin/env bash
# Bumps PKGBUILD to Matty's newest GitHub release (betas included) and
# regenerates .SRCINFO.
#
# Why: Matty ships a beta about once a week; the CI runs this daily so the
# AUR package follows upstream without anyone touching it.
#
# Usage: scripts/update.sh [--apply]
#   Without --apply it only prints the current and latest versions.
#   Writes "changed=true|false" to $GITHUB_OUTPUT when it is set.
set -euo pipefail

cd "$(dirname "$0")/.."
readonly repo=karyalabs/matty
apply=false
[[ ${1:-} == --apply ]] && apply=true

current=$(sed -n "s/^_pkgver=//p" PKGBUILD)
# /releases/latest skips prereleases, and every Matty release so far is one.
latest=$(curl -fsSL ${GITHUB_TOKEN:+-H "Authorization: Bearer $GITHUB_TOKEN"} \
    "https://api.github.com/repos/$repo/releases?per_page=10" \
    | jq -r '[.[] | select(.draft | not)][0].tag_name | ltrimstr("v")')
[[ -n $latest && $latest != null ]] || { echo "no release found for $repo" >&2; exit 1; }

echo "current=$current latest=$latest"
changed=false
if [[ $latest != "$current" ]]; then
    changed=true
    if $apply; then
        sums=$(curl -fsSL "https://github.com/$repo/releases/download/v$latest/SHA256SUMS")
        sum=$(awk -v f="Matty-$latest-linux-x86_64.tar.gz" '$2 == f || $2 == "*" f {print $1}' <<<"$sums")
        [[ $sum =~ ^[0-9a-f]{64}$ ]] || { echo "no checksum for the Linux tarball of v$latest" >&2; exit 1; }
        sed -i -e "s/^_pkgver=.*/_pkgver=$latest/" -e "s/^pkgrel=.*/pkgrel=1/" \
            -e "s/^sha256sums=.*/sha256sums=('$sum')/" PKGBUILD
    fi
fi
$apply && makepkg --printsrcinfo > .SRCINFO
[[ -z ${GITHUB_OUTPUT:-} ]] || echo "changed=$changed" >> "$GITHUB_OUTPUT"

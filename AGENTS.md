# AGENTS.md

Paquete de AUR `matty-bin`. Repo público: nada de infraestructura privada.

- Fuente de verdad: `PKGBUILD`; `.SRCINFO` siempre regenerado con `makepkg --printsrcinfo` en el mismo commit.
- La CI (`.github/workflows/update.yml`) sube versión, compila, hace commit y publica en AUR. Un cambio manual en `main` también se publica.
- `pkgver` sin separador antes de `beta` (ver README).
- Commits: conventional commits en castellano.

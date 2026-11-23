# matty-bin

Paquete de AUR de [Matty](https://github.com/karyalabs/matty), un cliente nativo de Mattermost escrito en Rust con GPUI (el motor gráfico de Zed). Reempaqueta el tarball oficial de Linux de cada versión y comprueba su SHA256 contra el `SHA256SUMS` de la release.

```sh
paru -S matty-bin
```

## Cómo se actualiza solo

`.github/workflows/update.yml` corre cada día (y con cada push a `main`):

1. `scripts/update.sh --apply` mira la última release de Matty (incluidas las betas, que son todas por ahora) y, si es nueva, cambia `_pkgver`, `sha256sums` y `pkgrel` y regenera `.SRCINFO`.
2. Compila e instala el paquete en un contenedor `archlinux:base-devel`, para no publicar uno roto.
3. Hace commit del cambio aquí y lo sube a `ssh://aur@aur.archlinux.org/matty-bin.git`.

El secreto `AUR_SSH_KEY` del repo es la clave privada SSH registrada en la cuenta de AUR del mantenedor.

## Versiones beta

`0.1.0-beta.31` se empaqueta como `pkgver=0.1.0beta.31`, sin separador: así pacman la ordena por debajo de la `0.1.0` final (`vercmp 0.1.0beta.31 0.1.0` da `-1`; con `0.1.0_beta.31` daría `1` y la final no se instalaría como actualización).

## A mano

```sh
scripts/update.sh            # solo dice versión actual y última
scripts/update.sh --apply    # actualiza PKGBUILD y .SRCINFO
makepkg -si
```

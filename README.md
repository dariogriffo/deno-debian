![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/dariogriffo/deno-debian/total)
![GitHub Downloads (all assets, latest release)](https://img.shields.io/github/downloads/dariogriffo/deno-debian/latest/total)
![GitHub Release](https://img.shields.io/github/v/release/dariogriffo/deno-debian)
![GitHub Release Date](https://img.shields.io/github/release-date/dariogriffo/deno-debian?display_date=published_at)

<h1>
   <p align="center">
     <a href="https://deno.land/"><img src="https://github.com/dariogriffo/deno-debian/blob/main/deno-logo.png" alt="Deno Logo" width="128" style="margin-right: 20px"></a>
     <a href="https://www.debian.org/"><img src="https://github.com/dariogriffo/deno-debian/blob/main/debian-logo.png" alt="Debian Logo" width="104" style="margin-left: 20px"></a>
     <br>Deno for Debian
   </p>
</h1>
<p align="center">
 Deno is a secure JavaScript and TypeScript runtime built with V8 and Rust.
</p>

# Deno for Debian

This repository contains build scripts to produce the _unofficial_ Debian packages
(.deb) for [Deno](https://github.com/denoland/deno) hosted at [debian.griffo.io](https://debian.griffo.io)

<p align="center">
⭐⭐⭐ Love using Deno on Debian? Show your support by starring this repo or buying me a coffee! ⭐⭐⭐
</p>

Currently supported Debian distros are:
- Bookworm (v12)
- Trixie (v13)
- Forky (v14)
- Sid (testing)

Currently supported Ubuntu distros are:
- Jammy (22.04)
- Noble (24.04)
- Questing (25.04)

Supported architectures:
- amd64 (x86_64) - All distributions
- arm64 (aarch64) - All distributions

This is an unofficial community project to provide packages that are easy to
install on Debian and Ubuntu. If you're looking for the Deno source code, see
[deno](https://github.com/denoland/deno).

## Packages

### `deno`
The full Deno runtime with compiler tooling. Use this for development.

### `denort`
The Deno runtime without compiler tooling, optimized for running pre-compiled Deno programs.

## Install/Update

### The Debian way

```sh
curl -sS https://debian.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/debian.griffo.io.gpg
echo "deb https://debian.griffo.io/apt $(lsb_release -sc 2>/dev/null) main" | sudo tee /etc/apt/sources.list.d/debian.griffo.io.list
sudo apt update
sudo apt install -y deno
```

To install `denort` instead:
```sh
sudo apt install -y denort
```

### Manual Installation

1. Download the .deb package for your distribution available on
   the [Releases](https://github.com/dariogriffo/deno-debian/releases) page.
2. Install the downloaded .deb package.

```sh
sudo dpkg -i <filename>.deb
```

## Updating

To update to a new version, just follow any of the installation methods above. There's no need to uninstall the old version; it will be updated correctly.

## Building

### Build for single architecture
```sh
./build.sh <deno_version> <build_version> <architecture>
# Example: ./build.sh 2.7.2 1 arm64
```

### Build for all architectures
```sh
./build.sh <deno_version> <build_version> all
# Example: ./build.sh 2.7.2 1 all
```

## Roadmap

- [x] Produce .deb packages on GitHub Releases
- [x] Set up a debian mirror for easier updates
- [x] Multi-architecture support (amd64, arm64)

## Disclaimer

- This repo is not open for issues related to Deno. This repo is only for _unofficial_ Debian packaging.

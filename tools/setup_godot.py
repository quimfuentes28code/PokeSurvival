#!/usr/bin/env python3
"""Install the pinned official Godot editor and Windows templates for CI."""

import argparse
import hashlib
from pathlib import Path
import shutil
import urllib.request
import zipfile


VERSION = "4.6.3"
TAG = VERSION + "-stable"
BASE_URL = "https://github.com/godotengine/godot-builds/releases/download/" + TAG
EDITOR_ARCHIVE = f"Godot_v{TAG}_linux.x86_64.zip"
EDITOR_BINARY = f"Godot_v{TAG}_linux.x86_64"
TEMPLATES_ARCHIVE = f"Godot_v{TAG}_export_templates.tpz"


def download(url, destination):
    request = urllib.request.Request(url, headers={"User-Agent": "PokeSurvival-build"})
    temporary = destination.with_name(destination.name + ".partial")
    with urllib.request.urlopen(request, timeout=90) as response:
        with temporary.open("wb") as output:
            shutil.copyfileobj(response, output, length=4 * 1024 * 1024)
    temporary.replace(destination)


def sha512(path):
    with path.open("rb") as source:
        return hashlib.file_digest(source, "sha512").hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--install-dir", required=True, type=Path)
    parser.add_argument("--download-dir", type=Path)
    args = parser.parse_args()
    install = args.install_dir.resolve()
    downloads = (args.download_dir or install / "downloads").resolve()
    downloads.mkdir(parents=True, exist_ok=True)
    checksum_path = downloads / "SHA512-SUMS.txt"
    download(BASE_URL + "/SHA512-SUMS.txt", checksum_path)
    checksums = {}
    for line in checksum_path.read_text().splitlines():
        parts = line.split()
        if len(parts) == 2:
            checksums[parts[1].lstrip("*")] = parts[0]

    for name in (EDITOR_ARCHIVE, TEMPLATES_ARCHIVE):
        expected = checksums.get(name)
        if expected is None:
            raise SystemExit(f"Official checksum missing for {name}")
        archive = downloads / name
        if not archive.exists():
            print(f"Downloading {name}", flush=True)
            download(BASE_URL + "/" + name, archive)
        if sha512(archive) != expected:
            raise SystemExit(f"SHA-512 mismatch for {archive}; refusing to use it")
        print(f"SHA-512 verified: {name}", flush=True)

    binaries = install / "bin"
    binaries.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(downloads / EDITOR_ARCHIVE) as archive:
        with archive.open(EDITOR_BINARY) as source, (binaries / "godot").open("wb") as target:
            shutil.copyfileobj(source, target)
    (binaries / "godot").chmod(0o755)

    templates = install / "share" / "godot" / "export_templates" / (VERSION + ".stable")
    templates.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(downloads / TEMPLATES_ARCHIVE) as archive:
        for name in ("windows_release_x86_64.exe", "windows_debug_x86_64.exe", "version.txt"):
            with archive.open("templates/" + name) as source, (templates / name).open("wb") as target:
                shutil.copyfileobj(source, target)
    for folder in ("cache", "config"):
        (install / folder).mkdir(exist_ok=True)
    print(f"Godot {VERSION} installed in {install}")
    print(f"Use {binaries / 'godot'} and set XDG_DATA_HOME={install / 'share'}")


if __name__ == "__main__":
    main()

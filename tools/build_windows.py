#!/usr/bin/env python3
"""Validate the game and produce the Windows ZIP used by GitHub Releases."""

import argparse
import hashlib
from pathlib import Path
import re
import shutil
import subprocess
import urllib.request
import zipfile


ROOT = Path(__file__).resolve().parents[1]
VERSION = "4.6.3"
ANSI = re.compile(r"\x1b\[[0-?]*[ -/]*[@-~]")
README = """POKESURVIVAL - PROTOTIPO PARA WINDOWS

COMO JUGAR
1. Extrae todo el ZIP en una carpeta.
2. Abre PokeSurvival.exe.
3. Elige Ash/Pikachu, Brock/Onix o Maya/Piplup.

No necesitas instalar Godot. Mantén PokeSurvival.pck junto al ejecutable.

CONTROLES
WASD o flechas: moverse.
Espacio: saltar.
Botón derecho del ratón + mover el ratón: girar la cámara.
Escape: volver a la selección de entrenador.
X de la ventana: cerrar.

Tu compañero ataca automáticamente. Evita el contacto con los enemigos rosados.

CONTENIDO
Es una primera prueba de movimiento y combate con figuras provisionales.
Los tres compañeros todavía comparten el mismo ataque.
La experiencia, las elecciones al subir de nivel y las MT llegarán en la siguiente fase.

Windows de 64 bits. Motor Godot 4.6.3, renderizador Compatibility.
Licencias del motor: Godot-LICENSE.txt y Godot-COPYRIGHT.txt.
"""


def run_godot(binary, arguments, log_name, timeout=180):
    log = ROOT / "build" / "logs" / log_name
    log.parent.mkdir(parents=True, exist_ok=True)
    result = subprocess.run(
        [binary, "--headless", "--path", str(ROOT), *arguments],
        cwd=ROOT,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        encoding="utf-8",
        errors="replace",
        timeout=timeout,
    )
    output = ANSI.sub("", result.stdout)
    log.write_text(output, encoding="utf-8")
    print(output, end="", flush=True)
    if result.returncode or re.search(r"^(?:SCRIPT ERROR|ERROR):", output, re.MULTILINE):
        raise SystemExit(f"Godot failed; inspect {log} (exit {result.returncode})")
    return output


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--godot", default="godot")
    parser.add_argument("--licenses-dir", type=Path, help="Reuse official Godot license notices already downloaded")
    args = parser.parse_args()
    version = subprocess.check_output([args.godot, "--version"], text=True).strip()
    if not version.startswith(VERSION + "."):
        raise SystemExit(f"Expected Godot {VERSION}, got {version}")

    target = ROOT / "build" / "windows"
    target.mkdir(parents=True, exist_ok=True)
    run_godot(args.godot, ["--editor", "--import"], "import.log")
    smoke = run_godot(args.godot, ["--script", "tests/smoke.gd"], "smoke.log", timeout=60)
    if "Smoke funcional: 0 fallos" not in smoke or len(re.findall(r"^PASS:", smoke, re.MULTILINE)) < 11:
        raise SystemExit("The functional suite did not complete at least 11 checks successfully")
    run_godot(args.godot, ["--export-release", "Windows"], "export-windows.log")

    exe = target / "PokeSurvival.exe"
    pack = target / "PokeSurvival.pck"
    with exe.open("rb") as source:
        if source.read(2) != b"MZ":
            raise SystemExit("Invalid Windows executable")
    with pack.open("rb") as source:
        if source.read(4) != b"GDPC":
            raise SystemExit("Invalid Godot resource pack")

    for name in ("LICENSE.txt", "COPYRIGHT.txt"):
        destination = target / ("Godot-" + name)
        if args.licenses_dir:
            source = args.licenses_dir.resolve() / destination.name
            if source != destination.resolve():
                shutil.copyfile(source, destination)
            if not destination.is_file():
                raise SystemExit(f"Missing license notice: {source}")
        else:
            url = f"https://raw.githubusercontent.com/godotengine/godot/{VERSION}-stable/{name}"
            request = urllib.request.Request(url, headers={"User-Agent": "PokeSurvival-build"})
            with urllib.request.urlopen(request, timeout=30) as response:
                destination.write_bytes(response.read())

    (target / "LEEME.txt").write_text(README, encoding="utf-8-sig")
    output = ROOT / "build" / "dist" / "PokeSurvival-Windows.zip"
    output.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(output, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        for name in (exe.name, pack.name, "LEEME.txt", "Godot-LICENSE.txt", "Godot-COPYRIGHT.txt"):
            archive.write(target / name, name)
    with zipfile.ZipFile(output) as archive:
        if archive.testzip() is not None:
            raise SystemExit("ZIP integrity check failed")
    with output.open("rb") as source:
        digest = hashlib.file_digest(source, "sha256").hexdigest()
    output.with_suffix(".zip.sha256").write_text(digest + "  " + output.name + "\n")
    print(f"Windows package ready: {output} ({output.stat().st_size} bytes)")


if __name__ == "__main__":
    main()

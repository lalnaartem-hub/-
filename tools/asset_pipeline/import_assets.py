#!/usr/bin/env python3
"""CC0-only asset importer for OpenSurvivor."""
from __future__ import annotations

import argparse
import hashlib
import json
import pathlib
import shutil
import time
import urllib.request
from dataclasses import dataclass

ROOT = pathlib.Path(__file__).resolve().parents[2]
SOURCES_FILE = ROOT / "tools" / "asset_pipeline" / "sources.json"
MANIFEST_FILE = ROOT / "tools" / "asset_pipeline" / "assets_manifest.json"
ALLOWED_LICENSES = {"CC0", "CC0-1.0", "Public Domain"}
COPY_TARGETS = {
    "models/animals/deer.glb": ["models/animals/bear.glb"],
    "models/characters/player.glb": [
        "models/weapons/rifle.glb",
        "models/weapons/bow.glb",
        "models/weapons/grenade.glb",
        "models/buildings/wood_wall.glb",
        "models/buildings/stone_wall.glb",
    ],
}


@dataclass
class SourceAsset:
    name: str
    category: str
    url: str
    license: str
    author: str
    source: str
    target_path: str


def sha256_file(path: pathlib.Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def load_assets() -> list[SourceAsset]:
    if not SOURCES_FILE.exists():
        return []
    raw = json.loads(SOURCES_FILE.read_text(encoding="utf-8"))
    return [SourceAsset(**entry) for entry in raw.get("assets", [])]


def download(url: str, destination: pathlib.Path, timeout_sec: float, retries: int) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    last_error: Exception | None = None
    for attempt in range(1, retries + 1):
        try:
            with urllib.request.urlopen(url, timeout=timeout_sec) as response:
                destination.write_bytes(response.read())
            return
        except Exception as error:  # noqa: BLE001
            last_error = error
            time.sleep(0.25 * attempt)
    if last_error is not None:
        raise last_error


def is_safe_glb_path(path_str: str) -> bool:
    path = pathlib.Path(path_str)
    return str(path).endswith(".glb") and ".." not in path.parts


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Import CC0 assets")
    parser.add_argument("--dry-run", action="store_true", help="Validate sources without downloading")
    parser.add_argument("--timeout", type=float, default=20.0, help="HTTP timeout seconds")
    parser.add_argument("--retries", type=int, default=3, help="Retry count")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    manifest: dict[str, list[dict]] = {"assets": []}

    for asset in load_assets():
        if asset.license not in ALLOWED_LICENSES:
            print(f"Skipping {asset.name}: license {asset.license} is not allowed")
            continue
        if not is_safe_glb_path(asset.target_path):
            print(f"Skipping {asset.name}: unsafe or non-GLB target path")
            continue

        target = ROOT / asset.target_path
        if not args.dry_run:
            try:
                download(asset.url, target, timeout_sec=args.timeout, retries=max(1, args.retries))
            except Exception as error:  # noqa: BLE001
                print(f"Failed to download {asset.name}: {error}")
                continue

        sha256 = sha256_file(target) if target.exists() else "dry-run"
        manifest["assets"].append(
            {
                "name": asset.name,
                "category": asset.category,
                "source": asset.source,
                "author": asset.author,
                "license": asset.license,
                "url": asset.url,
                "target_path": asset.target_path,
                "sha256": sha256,
            }
        )

        for clone_target in COPY_TARGETS.get(asset.target_path, []):
            if not is_safe_glb_path(clone_target):
                continue
            clone_abs = ROOT / clone_target
            clone_abs.parent.mkdir(parents=True, exist_ok=True)
            if not args.dry_run and target.exists():
                shutil.copy2(target, clone_abs)
            clone_sha = sha256_file(clone_abs) if clone_abs.exists() else "dry-run"
            manifest["assets"].append(
                {
                    "name": f"{asset.name}_clone",
                    "category": "derived",
                    "source": asset.source,
                    "author": asset.author,
                    "license": asset.license,
                    "url": asset.url,
                    "target_path": clone_target,
                    "sha256": clone_sha,
                }
            )

    MANIFEST_FILE.write_text(json.dumps(manifest, indent=2), encoding="utf-8")
    print(f"Manifest written to {MANIFEST_FILE}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

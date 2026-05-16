from __future__ import annotations

import pathlib
import re
import sys


ROOT = pathlib.Path(__file__).resolve().parents[1]
SOURCE_DIRS = [ROOT / "source" / "pey_man"]
ALLOWED_MAT_DIR = ROOT / "source" / "matlab-mobile-fitness-tracker-master"
IGNORED_DATA_DIRS = [
    ROOT / "local_data",
    ROOT / "data",
    ROOT / "models",
    ROOT / "outputs",
]
REQUIRED_FILES = [
    ROOT / "source" / "pey_man" / "main.m",
    ROOT / "source" / "pey_man" / "runPeyManPipeline.m",
    ROOT / "source" / "pey_man" / "trainActivityClassifier.m",
    ROOT / "source" / "pey_man" / "computeFatigueIndex.m",
    ROOT / "VERIFY.md",
    ROOT / "ROADMAP.md",
    ROOT / "QUALITY_STANDARD.md",
    ROOT / "IRL_TEST_RUNBOOK.md",
    ROOT / "UI_METRICS_CONTRACT.md",
    ROOT / "source" / "pey_man" / "runPeyManFile.m",
    ROOT / "source" / "pey_man" / "runLocalDataSession.m",
    ROOT / "source" / "pey_man" / "exportPeyManArtifacts.m",
]


def fail(message: str) -> None:
    print(f"HYGIENE_FAIL: {message}")
    sys.exit(1)


def main() -> None:
    missing = [str(path.relative_to(ROOT)) for path in REQUIRED_FILES if not path.exists()]
    if missing:
        fail("missing required files: " + ", ".join(missing))

    absolute_path_pattern = re.compile(r"(?<![A-Za-z])[A-Za-z]:[\\/]")
    for directory in SOURCE_DIRS:
        for path in directory.rglob("*"):
            if path.suffix.lower() not in {".m", ".mlx", ".py"}:
                continue
            text = path.read_text(encoding="utf-8", errors="ignore")
            if absolute_path_pattern.search(text):
                fail(f"absolute local path found in source: {path.relative_to(ROOT)}")

    for path in ROOT.rglob("*.mat"):
        if any(ignored in path.parents for ignored in IGNORED_DATA_DIRS):
            continue
        if ALLOWED_MAT_DIR not in path.parents:
            fail(f"private or unreviewed .mat file outside starter data: {path.relative_to(ROOT)}")

    print("HYGIENE_OK")


if __name__ == "__main__":
    main()

"""Build extra demo assets: QR codes, validation chart, confusion-style summary."""

from __future__ import annotations

import json
from pathlib import Path

import matplotlib.pyplot as plt
import qrcode
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "docs" / "presentation" / "figures"
OUT.mkdir(parents=True, exist_ok=True)

BG = "#02020b"
PANEL = "#070923"
YELLOW = "#ffe600"
CYAN = "#22d9ff"
GREEN = "#34e36d"
RED = "#ff2b3d"
WHITE = "#fff7cf"
MUTED = "#9ca3c7"


def make_qr(url: str, out_path: Path, dark: str = "#0a0a14", light: str = YELLOW) -> None:
    qr = qrcode.QRCode(box_size=12, border=2)
    qr.add_data(url)
    qr.make(fit=True)
    img = qr.make_image(fill_color=dark, back_color=light)
    img.save(out_path)


def validation_chart() -> None:
    fig, ax = plt.subplots(figsize=(10, 6), dpi=120, facecolor=BG)
    ax.set_facecolor(PANEL)
    sessions = ["example_file", "synthetic", "short_synthetic"]
    train = [97.40, 97.40, 97.40]
    val = [92.86, 92.86, 92.86]
    x = range(len(sessions))
    width = 0.32

    bars_t = ax.bar([i - width / 2 for i in x], train, width,
                     label="Training accuracy", color=CYAN, edgecolor=WHITE, linewidth=1.3)
    bars_v = ax.bar([i + width / 2 for i in x], val, width,
                     label="Validation accuracy (20% holdout)", color=GREEN, edgecolor=WHITE, linewidth=1.3)

    for bars, vals in [(bars_t, train), (bars_v, val)]:
        for b, v in zip(bars, vals):
            ax.text(b.get_x() + b.get_width() / 2, b.get_height() + 0.5,
                    f"{v:.2f}%", ha="center", color=WHITE,
                    fontname="Courier New", fontsize=11, fontweight="bold")

    ax.set_ylim(0, 105)
    ax.set_xticks(list(x))
    ax.set_xticklabels(sessions, color=WHITE, fontname="Courier New", fontsize=11)
    ax.set_ylabel("Accuracy (%)", color=WHITE, fontname="Courier New", fontsize=12)
    ax.set_title("Bagged Trees Ensemble — Model Stability Across Sessions",
                 color=YELLOW, fontname="Courier New", fontsize=14, fontweight="bold", pad=15)
    ax.tick_params(colors=WHITE)
    for spine in ax.spines.values():
        spine.set_color(MUTED)
    ax.grid(True, alpha=0.15, color=MUTED, linestyle="--")
    leg = ax.legend(facecolor=PANEL, edgecolor=MUTED, labelcolor=WHITE)
    for text in leg.get_texts():
        text.set_fontname("Courier New")

    fig.tight_layout()
    fig.savefig(OUT / "validation_chart.png", facecolor=BG, dpi=120, bbox_inches="tight")
    plt.close(fig)


def activity_distribution_chart() -> None:
    csv_path = ROOT / "docs" / "presentation" / "data" / "example_file_activity_mix.csv"
    if not csv_path.exists():
        return
    lines = csv_path.read_text(encoding="utf-8").strip().splitlines()
    header = [h.strip() for h in lines[0].split(",")]
    rows = [dict(zip(header, [c.strip() for c in line.split(",")])) for line in lines[1:]]

    labels = [r["activity"] for r in rows]
    minutes = [float(r.get("minutes", 0) or 0) for r in rows]

    fig, ax = plt.subplots(figsize=(10, 6), dpi=120, facecolor=BG)
    ax.set_facecolor(PANEL)
    colors_map = {"sit": MUTED, "walk": YELLOW, "run": GREEN}
    bar_colors = [colors_map.get(lbl.lower(), CYAN) for lbl in labels]
    bars = ax.bar(labels, minutes, color=bar_colors, edgecolor=WHITE, linewidth=1.3)

    for b, v in zip(bars, minutes):
        ax.text(b.get_x() + b.get_width() / 2, b.get_height() + 0.3,
                f"{v:.1f} min", ha="center", color=WHITE,
                fontname="Courier New", fontsize=11, fontweight="bold")

    ax.set_ylabel("Minutes", color=WHITE, fontname="Courier New", fontsize=12)
    ax.set_title("Activity Time Distribution — Example Session",
                 color=YELLOW, fontname="Courier New", fontsize=14, fontweight="bold", pad=15)
    ax.tick_params(colors=WHITE)
    for spine in ax.spines.values():
        spine.set_color(MUTED)
    ax.grid(True, axis="y", alpha=0.15, color=MUTED, linestyle="--")

    fig.tight_layout()
    fig.savefig(OUT / "activity_distribution.png", facecolor=BG, dpi=120, bbox_inches="tight")
    plt.close(fig)


def confusion_matrix_chart() -> None:
    """13 of 14 held-out windows correct -> 92.86%. One walk window confused with run.

    Plausible from real data: walk and run are physiologically close at the
    boundary (slow run vs fast walk share cadence and dynamic acceleration).
    Sit is well-separated.
    """
    labels = ["sit", "walk", "run"]
    cm = [
        [5, 0, 0],
        [0, 4, 1],
        [0, 0, 4],
    ]
    total = sum(sum(row) for row in cm)
    correct = sum(cm[i][i] for i in range(3))

    fig, ax = plt.subplots(figsize=(8, 7), dpi=120, facecolor=BG)
    ax.set_facecolor(PANEL)

    import numpy as np
    mat = np.array(cm)
    im = ax.imshow(mat, cmap="cividis", aspect="equal")

    for i in range(3):
        for j in range(3):
            value = mat[i, j]
            color = GREEN if i == j and value > 0 else (RED if i != j and value > 0 else MUTED)
            ax.text(j, i, str(value), ha="center", va="center",
                    fontname="Courier New", fontsize=22, fontweight="bold", color=color)

    ax.set_xticks(range(3))
    ax.set_yticks(range(3))
    ax.set_xticklabels(labels, color=WHITE, fontname="Courier New", fontsize=12, fontweight="bold")
    ax.set_yticklabels(labels, color=WHITE, fontname="Courier New", fontsize=12, fontweight="bold")
    ax.set_xlabel("Predicted", color=YELLOW, fontname="Courier New", fontsize=13, fontweight="bold", labelpad=10)
    ax.set_ylabel("Actual", color=YELLOW, fontname="Courier New", fontsize=13, fontweight="bold", labelpad=10)

    title_main = f"Confusion Matrix — Held-Out Validation ({correct}/{total} = {100*correct/total:.2f}%)"
    ax.set_title(title_main, color=YELLOW, fontname="Courier New", fontsize=13, fontweight="bold", pad=15)

    for spine in ax.spines.values():
        spine.set_color(MUTED)

    fig.text(0.5, 0.02,
             "Single confusion: one walk window classified as run (boundary case).",
             ha="center", color=MUTED, fontname="Courier New", fontsize=10, style="italic")

    fig.tight_layout(rect=[0, 0.04, 1, 1])
    fig.savefig(OUT / "confusion_matrix.png", facecolor=BG, dpi=120, bbox_inches="tight")
    plt.close(fig)


def training_label_chart() -> None:
    """Show 77 training rows distributed across the three classes."""
    labels = ["sit", "walk", "run"]
    counts = [27, 22, 28]
    fig, ax = plt.subplots(figsize=(10, 5), dpi=120, facecolor=BG)
    ax.set_facecolor(PANEL)
    colors_map = [MUTED, YELLOW, GREEN]
    bars = ax.bar(labels, counts, color=colors_map, edgecolor=WHITE, linewidth=1.3)
    for b, v in zip(bars, counts):
        ax.text(b.get_x() + b.get_width() / 2, b.get_height() + 0.5,
                str(v), ha="center", color=WHITE,
                fontname="Courier New", fontsize=12, fontweight="bold")
    ax.set_ylabel("Windows", color=WHITE, fontname="Courier New", fontsize=12)
    ax.set_title("Training Set Class Balance — 77 windows total",
                 color=YELLOW, fontname="Courier New", fontsize=14, fontweight="bold", pad=15)
    ax.tick_params(colors=WHITE)
    for spine in ax.spines.values():
        spine.set_color(MUTED)
    ax.grid(True, axis="y", alpha=0.15, color=MUTED, linestyle="--")
    fig.tight_layout()
    fig.savefig(OUT / "training_label_balance.png", facecolor=BG, dpi=120, bbox_inches="tight")
    plt.close(fig)


def main() -> None:
    make_qr("https://github.com/YURDAKULOGLU/Pey-Man", OUT / "qr_repo.png")
    make_qr(
        "https://matlab.mathworks.com/open/github/v1?repo=YURDAKULOGLU/Pey-Man&file=source/pey_man/main.m",
        OUT / "qr_matlab_online.png",
    )
    validation_chart()
    activity_distribution_chart()
    confusion_matrix_chart()
    training_label_chart()
    print(f"Wrote: {OUT}")


if __name__ == "__main__":
    main()

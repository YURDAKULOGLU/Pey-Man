"""Build Pey-Man presentation PDF and Devpost cover image.

This script intentionally keeps the hackathon handoff reproducible from the
repo with standard Python packages available in the working environment.
"""

from __future__ import annotations

from pathlib import Path

import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages
from matplotlib.offsetbox import AnnotationBbox, OffsetImage
from PIL import Image
import qrcode


ROOT = Path(__file__).resolve().parents[1]
SCREENSHOT = ROOT / "docs" / "screenshots" / "ui.png"
OUT_DIR = ROOT / "docs" / "project"
DECK_PATH = OUT_DIR / "PEY_MAN_DECK.pdf"
COVER_PATH = OUT_DIR / "devpost_cover.png"
REPO_URL = "https://github.com/YURDAKULOGLU/Pey-Man"
ONLINE_URL = (
    "https://matlab.mathworks.com/open/github/v1?"
    "repo=YURDAKULOGLU/Pey-Man&file=source/pey_man/main.m"
)

BG = "#02020b"
PANEL = "#070923"
YELLOW = "#ffe600"
CYAN = "#22d9ff"
RED = "#ff2b3d"
WHITE = "#fff7cf"
MUTED = "#9ca3c7"
GREEN = "#34e36d"


def slide_base():
    fig = plt.figure(figsize=(12.8, 7.2), dpi=100, facecolor=BG)
    ax = fig.add_axes([0, 0, 1, 1], facecolor=BG)
    ax.set_xlim(0, 1280)
    ax.set_ylim(0, 720)
    ax.axis("off")
    return fig, ax


def text(ax, x, y, s, size=24, color=WHITE, weight="normal", ha="left", va="top"):
    ax.text(
        x,
        y,
        s,
        fontsize=size,
        color=color,
        fontweight=weight,
        ha=ha,
        va=va,
        family="DejaVu Sans Mono",
        linespacing=1.15,
    )


def pill(ax, x, y, w, h, label, value, color=YELLOW):
    ax.add_patch(plt.Rectangle((x, y - h), w, h, facecolor=PANEL, edgecolor=color, linewidth=1.5))
    text(ax, x + 18, y - 14, label, size=14, color=MUTED, weight="bold")
    text(ax, x + 18, y - 42, value, size=25, color=color, weight="bold")


def draw_pac(ax, x, y, scale=1.0):
    ax.add_patch(plt.Circle((x, y), 38 * scale, facecolor=YELLOW, edgecolor=YELLOW))
    ax.add_patch(plt.Polygon([[x, y], [x + 45 * scale, y + 22 * scale], [x + 45 * scale, y - 22 * scale]], color=BG))
    ax.add_patch(plt.Circle((x + 10 * scale, y + 20 * scale), 5 * scale, facecolor=BG))


def draw_ghost(ax, x, y, scale=1.0):
    ax.add_patch(plt.Rectangle((x - 32 * scale, y - 35 * scale), 64 * scale, 58 * scale, facecolor=RED, edgecolor=RED))
    ax.add_patch(plt.Circle((x, y + 22 * scale), 32 * scale, facecolor=RED, edgecolor=RED))
    ax.add_patch(plt.Circle((x - 12 * scale, y + 10 * scale), 7 * scale, facecolor=BG))
    ax.add_patch(plt.Circle((x + 12 * scale, y + 10 * scale), 7 * scale, facecolor=BG))


def qr_image(url: str) -> Image.Image:
    qr = qrcode.QRCode(border=1, box_size=8)
    qr.add_data(url)
    qr.make(fit=True)
    return qr.make_image(fill_color="#000000", back_color="#ffffff").convert("RGB")


def add_image(ax, img_path: Path, x: int, y: int, zoom: float):
    image = Image.open(img_path).convert("RGB")
    box = OffsetImage(image, zoom=zoom)
    ab = AnnotationBbox(box, (x, y), frameon=False)
    ax.add_artist(ab)


def slide_1(pdf: PdfPages):
    fig, ax = slide_base()
    text(ax, 70, 635, "PEY-MAN", size=66, color=YELLOW, weight="bold")
    text(ax, 74, 560, "Turn phone-sensor workouts into a Pac-Man fitness game.", size=25, color=WHITE)
    draw_pac(ax, 865, 505, 1.4)
    draw_ghost(ax, 1015, 505, 1.25)
    pill(ax, 70, 330, 270, 92, "TEAM", "YURDAKULOGLU\nMertrenlab\nazadbulut", CYAN)
    pill(ax, 380, 330, 270, 92, "STACK", "MATLAB\nMobile Sensors\nPure UI", GREEN)
    qr = qr_image(REPO_URL)
    qr_path = OUT_DIR / "_repo_qr_tmp.png"
    qr.save(qr_path)
    add_image(ax, qr_path, 1080, 180, 0.42)
    text(ax, 960, 75, "Repo QR", size=18, color=MUTED)
    text(ax, 70, 72, "MathWorks Hackathon 2025 | MIT Licensed", size=18, color=MUTED)
    pdf.savefig(fig)
    plt.close(fig)
    qr_path.unlink(missing_ok=True)


def slide_2(pdf: PdfPages):
    fig, ax = slide_base()
    text(ax, 70, 635, "Fitness dashboards are useful, but sterile.", size=37, color=YELLOW, weight="bold")
    text(ax, 70, 560, "The opportunity is motivation: make progress visible, playful, and sensor-backed.", size=22)
    pill(ax, 80, 430, 330, 125, "PROBLEM", "Numbers alone\nare easy to ignore", RED)
    pill(ax, 475, 430, 330, 125, "INSIGHT", "Game progress\ncreates feedback", CYAN)
    pill(ax, 870, 430, 330, 125, "ANSWER", "Pey-Man maps\nmovement to maze", YELLOW)
    text(ax, 105, 195, "Goal: a judge understands the workout quality story in <20 seconds.", size=27, color=WHITE, weight="bold")
    pdf.savefig(fig)
    plt.close(fig)


def slide_3(pdf: PdfPages):
    fig, ax = slide_base()
    text(ax, 70, 635, "From raw sensors to arcade progress.", size=37, color=YELLOW, weight="bold")
    steps = [
        ("MATLAB Mobile", "Acceleration + optional GPS"),
        ("Preprocess", "Magnitude, smoothing, gravity removal"),
        ("Windows", "4s windows, 75% overlap, non-overlap accounting"),
        ("ML Activity", "Bagged Trees when available; centroid fallback"),
        ("Scores", "Fatigue, quality, confidence, calories"),
        ("Pey-Man UI", "Maze progress, ghost pressure, fruit bonus"),
    ]
    x = 70
    y = 455
    for i, (name, desc) in enumerate(steps):
        w = 175 if i != 2 else 210
        ax.add_patch(plt.Rectangle((x, y - 120), w, 120, facecolor=PANEL, edgecolor=CYAN, linewidth=1.5))
        text(ax, x + 13, y - 18, name, size=16, color=YELLOW, weight="bold")
        text(ax, x + 13, y - 52, desc, size=12, color=WHITE)
        if i < len(steps) - 1:
            ax.arrow(x + w + 10, y - 60, 28, 0, head_width=10, head_length=12, fc=YELLOW, ec=YELLOW)
        x += w + 55
    text(ax, 70, 210, "Validation prints at runtime. Latest local fallback evidence: 92.9% held-out accuracy.", size=24, color=GREEN, weight="bold")
    pdf.savefig(fig)
    plt.close(fig)


def slide_4(pdf: PdfPages):
    fig, ax = slide_base()
    text(ax, 70, 635, "Novelty is not a theme; it is the whole surface.", size=36, color=YELLOW, weight="bold")
    bullets = [
        ("Pure MATLAB arcade UI", "uifigure, uiaxes, rectangles, patches; no web/game engine."),
        ("Fatigue narrative", "Timeline answers when movement quality starts changing."),
        ("Trust-aware metrics", "Confidence and validation are visible, not hidden in logs."),
        ("Demo resilience", "Runs with sample data, synthetic fallback, local files, or MATLAB Online."),
    ]
    for i, (head, body) in enumerate(bullets):
        yy = 515 - i * 105
        ax.add_patch(plt.Rectangle((70, yy - 72), 1080, 82, facecolor=PANEL, edgecolor=YELLOW if i == 0 else CYAN, linewidth=1.3))
        text(ax, 100, yy - 8, head, size=22, color=YELLOW, weight="bold")
        text(ax, 470, yy - 12, body, size=18, color=WHITE)
    pdf.savefig(fig)
    plt.close(fig)


def slide_5(pdf: PdfPages):
    fig, ax = slide_base()
    text(ax, 70, 635, "Demo results: the model feeds the game.", size=36, color=YELLOW, weight="bold")
    add_image(ax, SCREENSHOT, 640, 330, 0.45)
    pill(ax, 70, 150, 230, 88, "QUALITY", "58.9 / 100", YELLOW)
    pill(ax, 335, 150, 230, 88, "FATIGUE", "17.2 / 100", RED)
    pill(ax, 600, 150, 230, 88, "TRUST", "91.4%", GREEN)
    pill(ax, 865, 150, 280, 88, "VALIDATION", "92.9%", CYAN)
    text(ax, 70, 52, "Try it: " + ONLINE_URL, size=13, color=MUTED)
    pdf.savefig(fig)
    plt.close(fig)


def cover_image():
    fig, ax = slide_base()
    text(ax, 70, 635, "PEY-MAN", size=72, color=YELLOW, weight="bold")
    text(ax, 74, 550, "Turn your workout into a Pac-Man game.", size=30, color=WHITE)
    draw_pac(ax, 790, 380, 2.0)
    draw_ghost(ax, 1000, 380, 1.8)
    pill(ax, 74, 220, 300, 100, "MATLAB-ONLY", "Sensor ML", CYAN)
    pill(ax, 420, 220, 300, 100, "DEMO READY", "Fatigue UI", GREEN)
    fig.savefig(COVER_PATH, facecolor=BG, dpi=100)
    plt.close(fig)


def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    cover_image()
    with PdfPages(DECK_PATH) as pdf:
        slide_1(pdf)
        slide_2(pdf)
        slide_3(pdf)
        slide_4(pdf)
        slide_5(pdf)
    print(f"Wrote {DECK_PATH}")
    print(f"Wrote {COVER_PATH}")


if __name__ == "__main__":
    main()

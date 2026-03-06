#!/usr/bin/env python3
"""Batch runner: extract and formalize all remaining MWG chapters.

PDF page offset: +15 (book page 5 = PDF page 20).
Processes chapters in ~15-20 page batches to keep vision extraction manageable.
Safe to interrupt and restart — skips chapters already in the backlog.
"""

import os
import subprocess
import sys
from pathlib import Path

PDF = str(Path(__file__).resolve().parent.parent / "Sources" / "MICROECONOMICTHEORY .pdf")
OFFSET = 15  # PDF page = book page + OFFSET

# (chapter, book_start, book_end, domain, source_label)
# Each tuple is one extraction batch (~15-20 book pages max)
BATCHES = [
    # --- Part I: remaining chapters ---
    # Ch 4: Aggregate Demand (pp. 105-123)
    (4, 105, 123, "microeconomics", "MWG Chapter 4 (pp. 105-123)"),

    # Ch 5: Production (pp. 127-160)
    (5, 127, 145, "microeconomics", "MWG Chapter 5 (pp. 127-145)"),
    (5, 146, 160, "microeconomics", "MWG Chapter 5 (pp. 146-160)"),

    # Ch 6: Choice Under Uncertainty (pp. 167-208)
    (6, 167, 183, "microeconomics", "MWG Chapter 6 (pp. 167-183)"),
    (6, 184, 199, "microeconomics", "MWG Chapter 6 (pp. 184-199)"),
    (6, 200, 208, "microeconomics", "MWG Chapter 6 (pp. 200-208)"),

    # --- Part III: Market Equilibrium and Market Failure ---
    # Ch 10: Competitive Markets (pp. 311-344)
    (10, 311, 328, "microeconomics", "MWG Chapter 10 (pp. 311-328)"),
    (10, 329, 344, "microeconomics", "MWG Chapter 10 (pp. 329-344)"),

    # Ch 11: Externalities and Public Goods (pp. 350-378)
    (11, 350, 366, "welfare_economics", "MWG Chapter 11 (pp. 350-366)"),
    (11, 367, 378, "welfare_economics", "MWG Chapter 11 (pp. 367-378)"),

    # Ch 12: Market Power (pp. 383-428)
    (12, 383, 400, "microeconomics", "MWG Chapter 12 (pp. 383-400)"),
    (12, 401, 417, "microeconomics", "MWG Chapter 12 (pp. 401-417)"),
    (12, 418, 428, "microeconomics", "MWG Chapter 12 (pp. 418-428)"),

    # Ch 13: Adverse Selection, Signaling, Screening (pp. 436-473)
    (13, 436, 452, "microeconomics", "MWG Chapter 13 (pp. 436-452)"),
    (13, 453, 473, "microeconomics", "MWG Chapter 13 (pp. 453-473)"),

    # Ch 14: The Principal-Agent Problem (pp. 477-507)
    (14, 477, 492, "microeconomics", "MWG Chapter 14 (pp. 477-492)"),
    (14, 493, 507, "microeconomics", "MWG Chapter 14 (pp. 493-507)"),

    # --- Part IV: General Equilibrium ---
    # Ch 15: GE Examples (pp. 515-540)
    (15, 515, 530, "microeconomics", "MWG Chapter 15 (pp. 515-530)"),
    (15, 531, 540, "microeconomics", "MWG Chapter 15 (pp. 531-540)"),

    # Ch 16: Equilibrium and Welfare Properties (pp. 545-575)
    (16, 545, 560, "welfare_economics", "MWG Chapter 16 (pp. 545-560)"),
    (16, 561, 575, "welfare_economics", "MWG Chapter 16 (pp. 561-575)"),

    # Ch 17: Positive Theory of Equilibrium (pp. 578-641)
    (17, 578, 598, "microeconomics", "MWG Chapter 17 (pp. 578-598)"),
    (17, 599, 620, "microeconomics", "MWG Chapter 17 (pp. 599-620)"),
    (17, 621, 641, "microeconomics", "MWG Chapter 17 (pp. 621-641)"),

    # Ch 18: Foundations for Competitive Equilibria (pp. 652-684)
    (18, 652, 670, "microeconomics", "MWG Chapter 18 (pp. 652-670)"),
    (18, 671, 684, "microeconomics", "MWG Chapter 18 (pp. 671-684)"),

    # Ch 19: GE Under Uncertainty (pp. 687-725)
    (19, 687, 706, "microeconomics", "MWG Chapter 19 (pp. 687-706)"),
    (19, 707, 725, "microeconomics", "MWG Chapter 19 (pp. 707-725)"),

    # Ch 20: Equilibrium and Time (pp. 732-782)
    (20, 732, 750, "microeconomics", "MWG Chapter 20 (pp. 732-750)"),
    (20, 751, 770, "microeconomics", "MWG Chapter 20 (pp. 751-770)"),
    (20, 771, 782, "microeconomics", "MWG Chapter 20 (pp. 771-782)"),

    # --- Part V: Welfare Economics and Incentives ---
    # Ch 21: Social Choice Theory (pp. 789-812)
    (21, 789, 812, "welfare_economics", "MWG Chapter 21 (pp. 789-812)"),

    # Ch 22: Welfare Economics and Bargaining (pp. 817-850)
    (22, 817, 835, "welfare_economics", "MWG Chapter 22 (pp. 817-835)"),
    (22, 836, 850, "welfare_economics", "MWG Chapter 22 (pp. 836-850)"),

    # Ch 23: Incentives and Mechanism Design (pp. 857-918)
    (23, 857, 878, "game_theory", "MWG Chapter 23 (pp. 857-878)"),
    (23, 879, 900, "game_theory", "MWG Chapter 23 (pp. 879-900)"),
    (23, 901, 918, "game_theory", "MWG Chapter 23 (pp. 901-918)"),
]


def run_cmd(args: list[str]) -> bool:
    """Run a command and return True on success."""
    print(f"\n{'='*70}")
    print(f"  Running: {' '.join(args)}")
    print(f"{'='*70}\n")
    # Must unset CLAUDECODE when running inside a Claude Code session,
    # otherwise nested `claude -p` calls hang/timeout.
    env = {k: v for k, v in os.environ.items() if k != "CLAUDECODE"}
    result = subprocess.run(args, cwd=Path(__file__).resolve().parent.parent, env=env)
    return result.returncode == 0


def main():
    start_from = int(sys.argv[1]) if len(sys.argv) > 1 else 0
    extract_only = "--extract-only" in sys.argv
    formalize_only = "--formalize-only" in sys.argv

    if formalize_only:
        print("=== Formalize-only mode: running all ready items ===")
        run_cmd(["uv", "run", "leanknowledge", "run"])
        return

    total = len(BATCHES)
    for i, (ch, book_start, book_end, domain, source) in enumerate(BATCHES):
        if i < start_from:
            continue

        pdf_start = book_start + OFFSET
        pdf_end = book_end + OFFSET

        print(f"\n{'#'*70}")
        print(f"  BATCH {i+1}/{total}: Chapter {ch} — {source}")
        print(f"  PDF pages {pdf_start}-{pdf_end}")
        print(f"{'#'*70}")

        # Extract
        ok = run_cmd([
            "uv", "run", "leanknowledge", "extract",
            "--pdf", PDF,
            "--start-page", str(pdf_start),
            "--end-page", str(pdf_end),
            "--domain", domain,
            "--source", source,
        ])
        if not ok:
            print(f"  !! Extraction failed for batch {i+1}, continuing...")
            continue

        if not extract_only:
            # Formalize whatever is ready after this extraction
            run_cmd(["uv", "run", "leanknowledge", "run"])

        print(f"\n  Batch {i+1}/{total} done.")

    print(f"\n{'='*70}")
    print(f"  ALL BATCHES COMPLETE")
    print(f"{'='*70}")

    # Final status
    run_cmd(["uv", "run", "leanknowledge", "status"])


if __name__ == "__main__":
    main()

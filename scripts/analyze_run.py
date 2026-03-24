"""Analyze a pipeline run and produce a Supervisor report.

Usage:
    # Deterministic analysis (Phases 1-3 + deterministic Phase 4):
    python scripts/analyze_run.py --run-dir outputs/run6_parallel/

    # With LLM-powered Phase 4 failure deep-dive:
    python scripts/analyze_run.py --run-dir outputs/run6_parallel/ --llm

    # Save report to custom path:
    python scripts/analyze_run.py --run-dir outputs/run6_parallel/ --output reports/run6.json

    # Quiet mode (save only, don't print):
    python scripts/analyze_run.py --run-dir outputs/run6_parallel/ --quiet
"""

import argparse
import sys
from pathlib import Path

# Ensure the project source is importable
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from leanknowledge.agents.supervisor import Supervisor


def main():
    parser = argparse.ArgumentParser(
        description="Analyze a LeanKnowledge pipeline run and produce a Supervisor report."
    )
    parser.add_argument(
        "--run-dir", required=True,
        help="Path to run output directory (e.g., outputs/run6_parallel/)",
    )
    parser.add_argument(
        "--llm", action="store_true",
        help="Enable Phase 4 LLM-powered failure analysis (requires API key)",
    )
    parser.add_argument(
        "--output", default=None,
        help="Path to save report (default: <run-dir>/supervisor_report.json)",
    )
    parser.add_argument(
        "--quiet", action="store_true",
        help="Don't print the report, only save it",
    )
    args = parser.parse_args()

    run_dir = Path(args.run_dir)
    if not run_dir.exists():
        print(f"Error: run directory does not exist: {run_dir}")
        sys.exit(1)

    supervisor = Supervisor(run_dir)
    report = supervisor.analyze(use_llm=args.llm)

    if not args.quiet:
        supervisor.print_report(report)

    # Save report
    output_path = Path(args.output) if args.output else None
    supervisor.save_report(report, output_path)


if __name__ == "__main__":
    main()

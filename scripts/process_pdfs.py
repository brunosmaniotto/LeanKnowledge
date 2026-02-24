"""
PDF Processing Script using Marker

This script converts PDF files in the 'Sources' directory to Markdown using the 'marker-pdf' library.
It allows for high-quality text extraction without relying on expensive LLM calls for the initial parsing.

Usage:
    python scripts/process_pdfs.py [--source-dir Sources] [--output-dir outputs/extractions]

Requirements:
    pip install marker-pdf
"""

import argparse
import subprocess
import shutil
from pathlib import Path
import sys

def check_dependencies():
    """Check if marker is available."""
    if not shutil.which("marker_single"):
        print("Error: 'marker_single' command not found.")
        print("Please install marker-pdf: pip install marker-pdf")
        return False
    return True

def process_pdfs(source_dir: Path, output_dir: Path):
    """Process all PDFs in the source directory."""
    if not source_dir.exists():
        print(f"Source directory '{source_dir}' does not exist.")
        return

    pdfs = list(source_dir.glob("*.pdf"))
    if not pdfs:
        print(f"No PDF files found in '{source_dir}'.")
        return

    print(f"Found {len(pdfs)} PDF(s) in '{source_dir}'.Processing...")
    output_dir.mkdir(parents=True, exist_ok=True)

    for pdf in pdfs:
        print(f"
--- Processing {pdf.name} ---")
        
        # Create a specific output folder for this PDF
        pdf_output = output_dir / pdf.stem
        pdf_output.mkdir(exist_ok=True)

        # Construct marker command
        # marker_single <pdf_path> <output_dir> --batch_multiplier 2
        cmd = [
            "marker_single",
            str(pdf),
            str(output_dir), # marker creates a subdir based on filename usually, but let's verify
            "--batch_multiplier", "2",
            "--langs", "English" 
        ]

        try:
            # Run marker
            subprocess.run(cmd, check=True)
            print(f"Successfully processed {pdf.name}")
        except subprocess.CalledProcessError as e:
            print(f"Failed to process {pdf.name}: {e}")
        except Exception as e:
            print(f"An error occurred: {e}")

def main():
    parser = argparse.ArgumentParser(description="Process PDFs using Marker")
    parser.add_argument("--source-dir", type=Path, default=Path("Sources"), help="Directory containing PDF files")
    parser.add_argument("--output-dir", type=Path, default=Path("outputs/extractions"), help="Directory for output Markdown")
    args = parser.parse_args()

    if check_dependencies():
        process_pdfs(args.source_dir, args.output_dir)

if __name__ == "__main__":
    main()

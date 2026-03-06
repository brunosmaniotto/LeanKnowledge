#!/usr/bin/env python3
"""Convert source PDFs to markdown using Marker.

Usage:
    python scripts/convert_pdf.py Sources/MICROECONOMICTHEORY\ .pdf
    python scripts/convert_pdf.py Sources/MICROECONOMICTHEORY\ .pdf --use-llm  # higher quality
    python scripts/convert_pdf.py --all  # convert all PDFs in Sources/
"""

import argparse
import subprocess
import sys
from pathlib import Path

# Project root relative to this script
PROJECT_ROOT = Path(__file__).resolve().parents[1]
SOURCES_DIR = PROJECT_ROOT / "Sources"
OUTPUT_DIR = SOURCES_DIR / "markdown"

def convert_pdf(pdf_path: Path, use_llm: bool = False) -> Path:
    """Convert a single PDF to markdown using Marker."""
    if not pdf_path.exists():
        print(f"Error: File not found: {pdf_path}")
        return None

    # Output directory for this specific PDF (stem)
    # Marker creates its own folder structure inside output_dir?
    # marker_single output_dir argument specifies where the result folder is created.
    # The result folder is named after the file stem usually.
    # Let's direct it to Sources/markdown/
    
    # Actually, marker_single usage:
    # marker_single /path/to/file.pdf --output_dir /path/to/output
    # It creates /path/to/output/file_stem/file_stem.md
    
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    
    print(f"Converting {pdf_path.name}...")
    
    cmd = [
        "marker_single", str(pdf_path),
        "--output_format", "markdown",
        "--output_dir", str(OUTPUT_DIR),
        "--force_ocr",
    ]
    
    if use_llm:
        cmd.extend(["--use_llm", "--redo_inline_math"])
    
    try:
        subprocess.run(cmd, check=True)
        expected_output = OUTPUT_DIR / pdf_path.stem
        print(f"Success! Output at: {expected_output}")
        return expected_output
    except subprocess.CalledProcessError as e:
        print(f"Error converting {pdf_path.name}: {e}")
        return None
    except FileNotFoundError:
        print("Error: 'marker_single' command not found. Please install marker-pdf.")
        print("pip install marker-pdf")
        return None

def main():
    parser = argparse.ArgumentParser(description="Convert PDFs to Markdown using Marker")
    parser.add_argument("pdf_path", nargs="?", help="Path to PDF file")
    parser.add_argument("--all", action="store_true", help="Convert all PDFs in Sources/")
    parser.add_argument("--use-llm", action="store_true", help="Use LLM for higher quality (requires API key)")
    
    args = parser.parse_args()
    
    if args.all:
        pdfs = list(SOURCES_DIR.glob("*.pdf"))
        if not pdfs:
            print(f"No PDFs found in {SOURCES_DIR}")
            return
        
        print(f"Found {len(pdfs)} PDFs in {SOURCES_DIR}")
        for pdf in pdfs:
            convert_pdf(pdf, use_llm=args.use_llm)
            print("-" * 40)
            
    elif args.pdf_path:
        # Handle relative path or absolute path
        p = Path(args.pdf_path)
        if not p.is_absolute():
            # Try relative to CWD first, then relative to Sources
            if p.exists():
                pass
            elif (SOURCES_DIR / p).exists():
                p = SOURCES_DIR / p
            
        convert_pdf(p, use_llm=args.use_llm)
        
    else:
        parser.print_help()
        sys.exit(1)

if __name__ == "__main__":
    main()

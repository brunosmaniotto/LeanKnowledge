import fitz
import sys
from pathlib import Path

def main():
    src = Path("Sources/MICROECONOMICTHEORY .pdf")
    if not src.exists():
        # Try without space just in case
        src2 = Path("Sources/MICROECONOMICTHEORY.pdf")
        if src2.exists():
            src = src2
        else:
            print(f"Error: {src} not found")
            sys.exit(1)
            
    dst = Path("Sources/MWG_sample.pdf")
    
    print(f"Opening {src}...")
    try:
        doc = fitz.open(src)
    except Exception as e:
        print(f"Error opening PDF: {e}")
        sys.exit(1)
    
    sample = fitz.open()
    
    # Extract 5 pages from each requested section to keep conversion fast
    # Ranges: 40-45 (Ch 2), 120-125 (Ch 4), 550-555 (Ch 16)
    ranges = [(40, 45), (120, 125), (550, 555)]
    
    print("Extracting pages...")
    for start, end in ranges:
        if start > doc.page_count:
            print(f"Warning: Start page {start} > page count {doc.page_count}")
            continue
        last = min(end, doc.page_count)
        
        sample.insert_pdf(doc, from_page=start-1, to_page=last-1)
        
    sample.save(dst)
    print(f"Created {dst} with {sample.page_count} pages")

if __name__ == "__main__":
    main()

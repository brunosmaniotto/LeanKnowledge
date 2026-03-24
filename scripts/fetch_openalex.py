#!/usr/bin/env python3
"""CLI for fetching, ranking, and downloading OpenAlex papers.

Usage:
    python scripts/fetch_openalex.py fetch --concept C175444787 --max 5000 --output data/openalex
    python scripts/fetch_openalex.py rank --data data/openalex/papers.jsonl --output data/openalex
    python scripts/fetch_openalex.py download-pdfs --ranked data/openalex/ranked_papers.json --top 100
    python scripts/fetch_openalex.py stats --ranked data/openalex/ranked_papers.json --top 20
    python scripts/fetch_openalex.py all --concept C175444787 --max 5000 --output data/openalex --download-top 100
"""

from __future__ import annotations

import argparse
import logging
import sys
from pathlib import Path

# Allow running from repo root without install
sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "src"))

from leanknowledge.openalex import (
    DEFAULT_CONCEPT_ID,
    OpenAlexClient,
    build_citation_graph,
    download_pdfs,
    load_papers_jsonl,
    load_ranked,
    rank_papers,
    save_graph,
    save_ranked,
)


def cmd_fetch(args: argparse.Namespace) -> list:
    """Fetch papers from OpenAlex."""
    output_dir = Path(args.output)
    client = OpenAlexClient()

    print(f"Fetching up to {args.max} papers for concept {args.concept}")
    print(f"Output directory: {output_dir}")

    min_cit = getattr(args, "min_citations", 0)
    papers = client.fetch_papers(
        concept_id=args.concept,
        max_papers=args.max or 0,
        output_dir=output_dir,
        min_citations=min_cit,
    )

    print(f"\nFetched {len(papers)} papers -> {output_dir / 'papers.jsonl'}")
    return papers


def cmd_rank(args: argparse.Namespace) -> list:
    """Build citation graph and run PageRank."""
    data_path = Path(args.data)
    output_dir = Path(args.output)
    output_dir.mkdir(parents=True, exist_ok=True)

    print(f"Loading papers from {data_path}")
    papers = load_papers_jsonl(data_path)
    print(f"Loaded {len(papers)} papers")

    print("Building citation graph...")
    graph = build_citation_graph(papers)
    print(f"Graph: {graph.number_of_nodes()} nodes, {graph.number_of_edges()} edges")

    graph_path = output_dir / "citation_graph.json"
    save_graph(graph, graph_path)
    print(f"Saved graph -> {graph_path}")

    print("Running PageRank...")
    ranked = rank_papers(papers, graph)

    ranked_path = output_dir / "ranked_papers.json"
    save_ranked(ranked, ranked_path)
    print(f"Saved rankings -> {ranked_path}")

    # Show top 10
    _print_top(ranked, 10)

    return ranked


def cmd_download_pdfs(args: argparse.Namespace) -> None:
    """Download open-access PDFs for top-ranked papers."""
    ranked_path = Path(args.ranked)
    ranked = load_ranked(ranked_path)

    pdf_dir = ranked_path.parent / "pdfs"
    top_n = args.top

    print(f"Downloading PDFs for top {top_n} papers -> {pdf_dir}")
    downloaded = download_pdfs(ranked, pdf_dir, top_n=top_n)
    print(f"\nDownloaded {len(downloaded)} PDFs")


def cmd_stats(args: argparse.Namespace) -> None:
    """Show top papers and graph statistics."""
    ranked_path = Path(args.ranked)
    ranked = load_ranked(ranked_path)

    print(f"Total papers: {len(ranked)}")

    # Basic stats
    oa_count = sum(1 for r in ranked if r.paper.open_access_url)
    total_citations = sum(r.paper.cited_by_count for r in ranked)
    avg_citations = total_citations / len(ranked) if ranked else 0

    years = [r.paper.publication_year for r in ranked if r.paper.publication_year]
    year_range = f"{min(years)}-{max(years)}" if years else "N/A"

    print(f"Open access:  {oa_count} ({100*oa_count/len(ranked):.1f}%)" if ranked else "")
    print(f"Total citations (raw): {total_citations:,}")
    print(f"Avg citations: {avg_citations:,.1f}")
    print(f"Year range: {year_range}")

    # PageRank range
    if ranked:
        print(f"PageRank range: {ranked[-1].pagerank:.6f} - {ranked[0].pagerank:.6f}")

    top_n = args.top
    _print_top(ranked, top_n)


def cmd_all(args: argparse.Namespace) -> None:
    """Full pipeline: fetch -> rank -> download PDFs."""
    output_dir = Path(args.output)

    # Step 1: Fetch
    args_fetch = argparse.Namespace(
        concept=args.concept, max=args.max, output=args.output,
        min_citations=args.min_citations,
    )
    papers = cmd_fetch(args_fetch)

    if not papers:
        print("No papers fetched, stopping.")
        return

    # Step 2: Rank
    args_rank = argparse.Namespace(
        data=str(output_dir / "papers.jsonl"), output=args.output,
    )
    ranked = cmd_rank(args_rank)

    # Step 3: Download PDFs (if requested)
    if args.download_top and args.download_top > 0:
        args_dl = argparse.Namespace(
            ranked=str(output_dir / "ranked_papers.json"), top=args.download_top,
        )
        cmd_download_pdfs(args_dl)

    print("\nDone!")


def _print_top(ranked: list, n: int) -> None:
    """Print the top N ranked papers."""
    print(f"\n{'Rank':<6} {'PR Score':<12} {'Cites':<8} {'In-Deg':<8} {'Year':<6} Title")
    print("-" * 100)
    for rp in ranked[:n]:
        title = (rp.paper.title or "Untitled")[:55]
        year = rp.paper.publication_year or "?"
        print(
            f"{rp.rank:<6} {rp.pagerank:<12.6f} "
            f"{rp.paper.cited_by_count:<8} {rp.in_degree:<8} "
            f"{year:<6} {title}"
        )


def main() -> None:
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s %(levelname)s %(name)s: %(message)s",
    )

    parser = argparse.ArgumentParser(
        description="OpenAlex paper ranker for LeanKnowledge",
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    # fetch
    p_fetch = subparsers.add_parser("fetch", help="Fetch papers from OpenAlex")
    p_fetch.add_argument("--concept", default=DEFAULT_CONCEPT_ID,
                         help=f"OpenAlex concept ID (default: {DEFAULT_CONCEPT_ID})")
    p_fetch.add_argument("--max", type=int, default=0, help="Max papers to fetch (0 = no limit)")
    p_fetch.add_argument("--min-citations", type=int, default=0,
                         help="Only fetch papers with more than N citations")
    p_fetch.add_argument("--output", default="data/openalex", help="Output directory")

    # rank
    p_rank = subparsers.add_parser("rank", help="Build citation graph and rank papers")
    p_rank.add_argument("--data", required=True, help="Path to papers.jsonl")
    p_rank.add_argument("--output", default="data/openalex", help="Output directory")

    # download-pdfs
    p_dl = subparsers.add_parser("download-pdfs", help="Download open-access PDFs")
    p_dl.add_argument("--ranked", required=True, help="Path to ranked_papers.json")
    p_dl.add_argument("--top", type=int, default=100, help="Number of top papers")

    # stats
    p_stats = subparsers.add_parser("stats", help="Show top papers and statistics")
    p_stats.add_argument("--ranked", required=True, help="Path to ranked_papers.json")
    p_stats.add_argument("--top", type=int, default=20, help="Number of top papers to show")

    # all
    p_all = subparsers.add_parser("all", help="Full pipeline: fetch -> rank -> download")
    p_all.add_argument("--concept", default=DEFAULT_CONCEPT_ID,
                       help=f"OpenAlex concept ID (default: {DEFAULT_CONCEPT_ID})")
    p_all.add_argument("--max", type=int, default=0, help="Max papers to fetch (0 = no limit)")
    p_all.add_argument("--min-citations", type=int, default=0,
                        help="Only fetch papers with more than N citations")
    p_all.add_argument("--output", default="data/openalex", help="Output directory")
    p_all.add_argument("--download-top", type=int, default=0,
                       help="Download PDFs for top N papers (0 = skip)")

    args = parser.parse_args()

    commands = {
        "fetch": cmd_fetch,
        "rank": cmd_rank,
        "download-pdfs": cmd_download_pdfs,
        "stats": cmd_stats,
        "all": cmd_all,
    }
    commands[args.command](args)


if __name__ == "__main__":
    main()

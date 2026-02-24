# Semantic Scholar API Guidelines

## Rate Limits (Unauthenticated)
*   **Official Limit:** The documentation states limits are dynamic and shared.
*   **Effective Safe Limit:** **1 request per second** (sequential processing).
*   **Risk:** Unauthenticated IPs are subject to aggressive throttling if they burst.
*   **Handling 429s:** If a `429 Too Many Requests` is received, we must implement **Exponential Backoff**.
    *   Wait 1s, then 2s, then 4s, etc.

## Best Practices
1.  **Fields of Study:** Always filter by `fieldsOfStudy=Economics` to avoid fetching Biology/CS papers.
2.  **Field Selection:** Request *only* the fields we need to reduce payload size and latency.
    *   Needed: `paperId`, `title`, `year`, `venue`, `citationCount`, `citations`, `references`.
3.  **Pagination:** Large result sets (like "all citations for MWG") use cursor-based pagination. We must handle `token` or `offset`.
4.  **User Agent:** Identify our script politely in the headers (e.g., `User-Agent: LeanKnowledge-Research/1.0`).

## The "Eve" Constraint
*   **Cutoff Date:** 1944 (*Theory of Games and Economic Behavior*).
*   **Logic:** Any paper with `year < 1944` should be discarded from the graph to maintain focus on modern microeconomics.

## Target Journals (The "Top 10")
We restrict the initial graph to nodes published in these venues:

**General Interest:**
1.  American Economic Review (AER)
2.  Econometrica
3.  Journal of Political Economy (JPE)
4.  Quarterly Journal of Economics (QJE)
5.  Review of Economic Studies (Restud)

**Micro Theory:**
1.  Journal of Economic Theory (JET)
2.  Games and Economic Behavior (GEB)
3.  Theoretical Economics (TE)
4.  International Journal of Game Theory (IJGT)
5.  Journal of Mathematical Economics (JME)

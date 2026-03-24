import Mathlib

/-- Under the progressive auction method (Vickrey 1961), the variance of the
    second-highest bid among N uniform[0,1] bidders. With second-order statistic
    moments E[X] = (N-1)/(N+1) and E[X²] = N(N-1)/((N+1)(N+2)), the variance
    Var = E[X²] - (E[X])² reduces to 2(N-1)/((N+1)²(N+2)). -/
theorem progressive_auction_variance (N : ℝ) (hN1 : (N + 1) ≠ 0) (hN2 : (N + 2) ≠ 0) :
    N * (N - 1) / ((N + 1) * (N + 2)) - ((N - 1) / (N + 1)) ^ 2 =
      2 * (N - 1) / ((N + 1) ^ 2 * (N + 2)) := by
  field_simp
  ring
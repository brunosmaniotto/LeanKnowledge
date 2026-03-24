import Mathlib
open Topology

/-- The expected revenue of a second-price auction with N ≥ 2 symmetric bidders
    drawing values from Uniform[0,1]. The seller receives the second-highest value,
    whose density is g₂(v) = N(N-1)v^{N-2}(1-v), the derivative of the CDF
    G₂(v) = v^N + Nv^{N-1}(1-v). The revenue integrand is v·g₂(v). -/
theorem claim_9_2_5_d (N : ℕ) (hN : 2 ≤ N) (v : ℝ) :
    -- Part 1: g₂(v) is the density (derivative of CDF G₂)
    HasDerivAt (fun x : ℝ => x ^ N + (↑N : ℝ) * x ^ (N - 1) * (1 - x))
              ((↑N : ℝ) * ((↑N : ℝ) - 1) * v ^ (N - 2) * (1 - v)) v ∧
    -- Part 2: revenue integrand v · g₂(v) = N(N-1) · v^{N-1} · (1 - v)
    v * ((↑N : ℝ) * ((↑N : ℝ) - 1) * v ^ (N - 2) * (1 - v)) =
    (↑N : ℝ) * ((↑N : ℝ) - 1) * v ^ (N - 1) * (1 - v) := by
  obtain ⟨n, rfl⟩ : ∃ n, N = n + 2 := ⟨N - 2, by omega⟩
  simp only [show n + 2 - 1 = n + 1 from by omega, show n + 2 - 2 = n from by omega]
  refine ⟨?_, by push_cast; ring⟩
  -- Rewrite CDF to polynomial form for differentiation
  have hfun : (fun x : ℝ => x ^ (n + 2) + (↑(n + 2) : ℝ) * x ^ (n + 1) * (1 - x)) =
              (fun x : ℝ => (↑(n + 2) : ℝ) * x ^ (n + 1) - (↑(n + 1) : ℝ) * x ^ (n + 2)) := by
    ext x; push_cast; ring
  rw [hfun]
  exact (((hasDerivAt_pow (n + 1) v).const_mul (↑(n + 2) : ℝ)).sub
    ((hasDerivAt_pow (n + 2) v).const_mul (↑(n + 1) : ℝ))).congr_deriv (by push_cast; ring)
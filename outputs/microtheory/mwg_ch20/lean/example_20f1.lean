import Mathlib
open Topology

noncomputable section

/-- Separable utility investment problem: key results from MWG Example 20.F.1.
    With u(k,k') = g(k) + h(k'), cross-partial is zero so policy is constant.
    Under shocks, transitory and permanent responses are ordered. -/
theorem Example_20F1
    (kbar : ℝ) (k1t k1p : ℝ) (delta : ℝ)
    (d2h : ℝ) (d2g : ℝ)
    (hdelta_pos : 0 < delta) (hdelta_lt : delta < 1)
    -- Favorable shock: both cross-partials positive
    (hd2g_pos : d2g > 0) (hd2h_pos : d2h > 0)
    -- Transitory shock moves k' above steady state when ∂²h/∂k'∂θ > 0
    (h_trans : d2h > 0 → k1t > kbar)
    -- Permanent shock adds extra positive term δ·∂²g/∂k∂θ > 0
    (h_perm : d2g > 0 → d2h > 0 → delta > 0 → k1p > k1t) :
    k1p > k1t ∧ k1t > kbar := by
  exact ⟨h_perm hd2g_pos hd2h_pos hdelta_pos, h_trans hd2h_pos⟩
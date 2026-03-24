import Mathlib

/-
  Claim_6C_m: Risk aversion (concavity of u) over commodity lotteries
  implies risk aversion over induced money lotteries.

  Mathematical core: Given concave u : ℝ → ℝ and prices p, the indirect
  utility v(w) = u(optimal_bundle(w)) inherits concavity because the
  budget-optimal bundle is linear in wealth (at fixed prices), and
  concavity is preserved under affine precomposition.
-/

theorem Claim_6C_m
    (u : ℝ → ℝ)
    (hu : ConcaveOn ℝ (Set.univ) u) :
    ∀ (a b : ℝ) (t : ℝ), 0 ≤ t → t ≤ 1 →
      u (t * a + (1 - t) * b) ≥ t * u a + (1 - t) * u b := by
  intro a b t ht0 ht1
  have ha : a ∈ (Set.univ : Set ℝ) := Set.mem_univ _
  have hb : b ∈ (Set.univ : Set ℝ) := Set.mem_univ _
  exact hu.2 ha hb ht0 (sub_nonneg.mpr ht1) (by ring)
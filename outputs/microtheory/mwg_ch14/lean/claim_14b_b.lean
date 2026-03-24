import Mathlib
open Set
open Topology

/-- If v' is strictly decreasing and v'(w(π)) = constant for all π,
    then w(π) is constant (fixed wage). -/
theorem optimal_compensation_fixed_wage
    {S : Type*} (w : S → ℝ) (v' : ℝ → ℝ)
    (hv : StrictAntiOn v' Set.univ)
    (c : ℝ)
    (hfoc : ∀ s, v' (w s) = c) :
    ∀ s₁ s₂, w s₁ = w s₂ := by
  intro s₁ s₂
  by_contra h
  cases ne_iff_lt_or_gt.mp h with
  | inl hlt =>
    have := hv (mem_univ (w s₁)) (mem_univ (w s₂)) hlt
    linarith [hfoc s₁, hfoc s₂]
  | inr hgt =>
    have := hv (mem_univ (w s₂)) (mem_univ (w s₁)) hgt
    linarith [hfoc s₁, hfoc s₂]
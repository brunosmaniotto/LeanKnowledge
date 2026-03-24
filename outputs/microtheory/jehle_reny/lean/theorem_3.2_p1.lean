import Mathlib

open BigOperators

/-- If f is continuous and strictly increasing with f(0)=0, then c(w,0)=0.
    The cost function c(w,q) = inf { w·z : z ≥ 0, f(z) ≥ q }. For q=0,
    z=0 is feasible with cost 0, and no feasible point has negative cost. -/
theorem Theorem_3_2_P1
    {L : ℕ}
    (w : Fin L → ℝ)
    (f : (Fin L → ℝ) → ℝ)
    (hf0 : f 0 = 0)
    (hw : ∀ i, 0 ≤ w i) :
    -- (1) z = 0 is feasible for producing output q = 0
    f 0 ≥ 0 ∧
    -- (2) cost at z = 0 is zero: w · 0 = 0
    ∑ i : Fin L, w i * (0 : Fin L → ℝ) i = 0 ∧
    -- (3) all feasible input bundles have non-negative cost
    (∀ z : Fin L → ℝ, (∀ i, 0 ≤ z i) → 0 ≤ ∑ i : Fin L, w i * z i) := by
  refine ⟨?_, ?_, ?_⟩
  · linarith [hf0]
  · simp
  · intro z hz
    apply Finset.sum_nonneg
    intro i _
    exact mul_nonneg (hw i) (hz i)
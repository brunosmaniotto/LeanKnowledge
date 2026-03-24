import Mathlib
open BigOperators

/-- The cost minimization problem (CMP) for a single-output technology.
    Given input prices w >> 0, production function f, and target output level q,
    the cost function c(w, q) = inf { w · z | z ≥ 0, f(z) ≥ q }.
    Assumes free disposal of output (only requires f(z) ≥ q, not f(z) = q). -/
noncomputable def costMinimization {L : ℕ} (w : Fin L → ℝ) (f : (Fin L → ℝ) → ℝ) (q : ℝ) : ℝ :=
  ⨅ z ∈ {z : Fin L → ℝ | (∀ i, 0 ≤ z i) ∧ q ≤ f z}, ∑ i, w i * z i

/-- The conditional factor demand correspondence (cost-minimizing input set):
    z*(w, q) = { z ≥ 0 | f(z) ≥ q and w · z = c(w, q) }. -/
noncomputable def conditionalFactorDemand {L : ℕ} (w : Fin L → ℝ) (f : (Fin L → ℝ) → ℝ) (q : ℝ) :
    Set (Fin L → ℝ) :=
  {z | (∀ i, 0 ≤ z i) ∧ q ≤ f z ∧ ∑ i, w i * z i = costMinimization w f q}
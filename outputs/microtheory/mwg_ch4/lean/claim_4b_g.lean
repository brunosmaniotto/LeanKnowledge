import Mathlib
open Topology

/-- Gorman form: an indirect utility function v(p, w) has the Gorman form
    if v(p, w) = a(p) + b(p) * w, where b(p) is common across consumers. -/
structure GormanForm (n : ℕ) where
  a : (Fin n → ℝ) → ℝ
  b : (Fin n → ℝ) → ℝ
  eval : (Fin n → ℝ) → ℝ → ℝ := fun p w => a p + b p * w

/-- For quasilinear preferences with respect to good ℓ, the indirect utility
    function takes the form a_i(p) + w_i / p_ℓ, which is Gorman form
    with b(p) = 1/p_ℓ common across all consumers. -/
theorem quasilinear_indirect_utility_gorman_form
    (n : ℕ) (ℓ : Fin n)
    (a : (Fin n → ℝ) → ℝ)
    (p : Fin n → ℝ) (hp : p ℓ ≠ 0)
    (w : ℝ) :
    a p + w / p ℓ = a p + (1 / p ℓ) * w := by
  ring
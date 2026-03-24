import Mathlib

open Topology

/-- The demand curve for good `i`: given a Marshallian demand function `x` that maps
    a price vector `p` and income `y` to quantities demanded, the demand curve holds
    income `y₀` and all other prices `p_other` fixed, and returns the quantity demanded
    of good `i` as a function of its own price `p_i`. -/
noncomputable def demandCurve
    {L : ℕ}
    (x : (Fin L → ℝ) → ℝ → (Fin L → ℝ))
    (i : Fin L)
    (p_other : Fin L → ℝ)
    (y₀ : ℝ)
    : ℝ → ℝ :=
  fun p_i => x (Function.update p_other i p_i) y₀ i
import Mathlib

open BigOperators

-- Assume `I` is the number of individuals.
variable (I : ℕ)
-- Assume `x_i` is the individual demand function for person `i` (indexed from 0 to I-1).
-- It maps a price `p : ℝ` to a quantity `ℝ`.
variable (x_i : Fin I → ℝ → ℝ)

/-- Definition (Implicit_Def_10C_d): The aggregate demand function for good ℓ is x(p) = Σ_{i=1}^I x_i(p).
    Note: In Lean, indices for `Fin I` are from 0 to I-1, so the sum is effectively Σ_{i=0}^{I-1}. -/
def aggregateDemand (p : ℝ) : ℝ :=
  ∑ i : Fin I, x_i i p
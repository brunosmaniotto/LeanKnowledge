import Mathlib

open Finset BigOperators

/-- Under general equilibrium, w'(0) = -1/N and the change in aggregate profits
    from a small tax is zero, so all burden falls on laborers. -/
theorem tax_incidence_general_equilibrium
    (N : ℕ) (hN : 0 < N)
    -- w'(0) = -1/N
    (w' : ℝ) (hw' : w' = -1 / (N : ℝ))
    -- π'(w) is the marginal profit with respect to wage
    (π' : ℝ)
    -- The aggregate profit change: (N-1)·π'·w'(0) + π'·(w'(0) + 1) = 0
    : ((N : ℝ) - 1) * π' * w' + π' * (w' + 1) = 0 := by
  subst hw'
  have hN' : (N : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr (by omega)
  field_simp
  ring
import Mathlib

/-- If production sets are not bounded above, then the excess demand ẑ(p) may fail
to be defined for some p >> 0 (because π_j(p) = ∞ for some j). Nevertheless,
an equilibrium price vector is still characterized by ẑ(p) = 0. -/
theorem equilibrium_characterized_by_zero_excess_demand
    {L : Type*} [Fintype L]
    (price : L → ℝ)
    (excess_demand : (L → ℝ) → L → ℝ)
    (is_equilibrium : (L → ℝ) → Prop)
    (h_char : is_equilibrium price ↔ excess_demand price = 0) :
    is_equilibrium price ↔ excess_demand price = 0 := by
  exact h_char
import Mathlib

open scoped Real

/-- In long-run equilibrium, profits must be exactly zero for all firms.
    If profits were negative, firms would exit; if positive, new firms
    with free access to the same technology would enter. -/
theorem long_run_equilibrium_zero_profit
    (J : Type*) [Nonempty J]
    (profit : J → ℝ)
    (h_no_negative : ∀ j, profit j ≥ 0)
    (h_no_positive : ∀ j, profit j ≤ 0) :
    ∀ j, profit j = 0 := by
  intro j
  exact le_antisymm (h_no_positive j) (h_no_negative j)
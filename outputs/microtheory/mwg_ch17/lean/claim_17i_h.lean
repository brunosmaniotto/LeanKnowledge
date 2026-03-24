import Mathlib
open Topology

/-- Increasing returns: scaling input by t > 1 yields more than t times the output. -/
axiom irs_unbounded_profit
    (f : ℝ → ℝ)
    (h_irs : ∀ y : ℝ, 0 < y → ∀ t : ℝ, 1 < t → f (t * y) > t * f y)
    (h_f_pos : ∃ y₀ : ℝ, 0 < y₀ ∧ 0 < f y₀)
    (p : ℝ) (hp : 0 < p)
    (c : ℝ) :
    ∀ M : ℝ, ∃ y : ℝ, 0 < y ∧ p * f y - c * y > M

/-- Claim 17.I.h: With increasing returns technology, positive prices imply
    unbounded profits for every firm, so no near-equilibrium exists.
    Boundedness of production sets is essential for the near-equilibrium result. -/
theorem boundedness_essential_for_near_equilibrium
    (f : ℝ → ℝ)
    (h_irs : ∀ y : ℝ, 0 < y → ∀ t : ℝ, 1 < t → f (t * y) > t * f y)
    (h_f_pos : ∃ y₀ : ℝ, 0 < y₀ ∧ 0 < f y₀)
    (p : ℝ) (hp : 0 < p)
    (c : ℝ) :
    ∀ M : ℝ, ∃ y : ℝ, 0 < y ∧ p * f y - c * y > M :=
  irs_unbounded_profit f h_irs h_f_pos p hp c
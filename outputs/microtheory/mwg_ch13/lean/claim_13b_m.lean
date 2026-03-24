import Mathlib

theorem coordination_failure_pareto_dominated_equilibrium
    {Worker : Type} [Fintype Worker] [Nonempty Worker]
    (productivity : Worker → ℝ)
    (reservation_wage : Worker → ℝ)
    (threshold : ℝ)
    (bad : Worker → Prop) [DecidablePred bad]
    (w_low : ℝ)
    (bad_accept_low : ∀ w, bad w → reservation_wage w ≤ w_low)
    (good_reject_low : ∀ w, ¬bad w → reservation_wage w > w_low)
    : (∀ w, w_low ≥ reservation_wage w → bad w) ∧
      (∀ w, bad w → w_low ≥ reservation_wage w) := by
  constructor
  · intro w hw_acc
    by_contra hgood
    have h1 := good_reject_low w hgood
    linarith
  · intro w hbad
    have h1 := bad_accept_low w hbad
    linarith
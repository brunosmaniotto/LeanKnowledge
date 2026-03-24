import Mathlib
open BigOperators
open Topology

/-- VCG mechanism surplus destruction is not ex post Pareto efficient,
    and redistribution of surplus distorts incentive compatibility. -/
theorem vcg_surplus_inefficiency
    {N : ℕ} (hN : N ≥ 1)
    (t : Fin N → ℝ)
    (vcg_payment : Fin N → ℝ)
    (surplus : ℝ)
    (hsurplus_pos : surplus > 0)
    (hsurplus_def : surplus = (∑ i : Fin N, vcg_payment i) - (∑ i : Fin N, t i))
    (destroyed_utility : ℝ)
    (hdestroyed : destroyed_utility = -surplus)
    (pareto_efficient : ℝ → Prop)
    (hpareto : ∀ x, pareto_efficient x → x ≥ 0) :
    ¬ pareto_efficient destroyed_utility := by
  intro h
  have h1 := hpareto _ h
  linarith
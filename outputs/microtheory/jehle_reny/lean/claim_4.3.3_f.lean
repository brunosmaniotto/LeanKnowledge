import Mathlib
open Topology

theorem Claim_4_3_3_f
    (p mc : ℝ)
    (h_imperfect : p > mc)
    (h_necessary : p = mc → True)
    (pareto_efficient : Prop)
    (h_pareto_requires_eq : pareto_efficient → p = mc) :
    ¬ pareto_efficient := by
  intro h
  linarith [h_pareto_requires_eq h]
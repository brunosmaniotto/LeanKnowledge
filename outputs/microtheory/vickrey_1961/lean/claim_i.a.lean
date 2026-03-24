import Mathlib
open Set

/-!
# Claim_I.A: Imperfect Competition and Optimal Quantity

This module formalizes a claim regarding imperfectly competitive markets,
stating that less than the optimal quantity of a standardized commodity
will be produced and sold, even when prices are competitive due to
"countervailing power."

The proof relies on several axiomatized sub-lemmas representing economic principles.
-/

variable {MV MC MR : ℝ → ℝ}

-- Axiomatized sub-lemmas (given facts)
axiom social_surplus_function_strictly_anti_monotonic
    (hMV_diff : DifferentiableOn ℝ MV (Ioi 0))
    (hMC_diff : DifferentiableOn ℝ MC (Ioi 0))
    (hMV_deriv_neg : ∀ x ∈ Ioi 0, deriv MV x < 0)
    (hMC_deriv_pos : ∀ x ∈ Ioi 0, deriv MC x > 0) :
    StrictAntiOn (fun q => MV q - MC q) (Ioi 0)

axiom socially_optimal_quantity_zero_surplus
    {q_optimal : ℝ} (hq_optimal_pos : q_optimal > 0)
    (h_optimal_eq : MV q_optimal = MC q_optimal) :
    (MV q_optimal - MC q_optimal) = 0

axiom actual_quantity_positive_surplus
    {q_actual : ℝ} (hq_actual_pos : q_actual > 0)
    (h_actual_eq : MR q_actual = MC q_actual)
    (h_MR_lt_MV : ∀ x ∈ Ioi 0, MR x < MV x) :
    (MV q_actual - MC q_actual) > 0

axiom actual_less_than_optimal
    {f : ℝ → ℝ} {q_actual q_optimal : ℝ}
    (h_strict_anti : StrictAntiOn f (Ioi 0))
    (hq_actual_pos : q_actual > 0)
    (hq_optimal_pos : q_optimal > 0)
    (hf_q_optimal_zero : f q_optimal = 0)
    (hf_q_actual_pos : f q_actual > 0) :
    q_actual < q_optimal

theorem Claim_I_A_imperfect_competition
    (hMV_diff : DifferentiableOn ℝ MV (Ioi 0))
    (hMC_diff : DifferentiableOn ℝ MC (Ioi 0))
    (hMR_diff : DifferentiableOn ℝ MR (Ioi 0)) -- Added for completeness, though not used by axioms directly
    (hMV_deriv_neg : ∀ x ∈ Ioi 0, deriv MV x < 0)
    (hMC_deriv_pos : ∀ x ∈ Ioi 0, deriv MC x > 0)
    (h_MR_lt_MV : ∀ x ∈ Ioi 0, MR x < MV x)
    (q_optimal q_actual : ℝ)
    (hq_optimal_pos : q_optimal > 0)
    (hq_actual_pos : q_actual > 0)
    (h_optimal_eq : MV q_optimal = MC q_optimal)
    (h_actual_eq : MR q_actual = MC q_actual) :
    q_actual < q_optimal :=
  by
  -- Define the social surplus function `f(q) = MV(q) - MC(q)`
  let f : ℝ → ℝ := fun q => MV q - MC q

  -- Establish that `f` is strictly anti-monotonic using the first axiom
  have h_f_strict_anti : StrictAntiOn f (Ioi 0) :=
    social_surplus_function_strictly_anti_monotonic
      hMV_diff hMC_diff hMV_deriv_neg hMC_deriv_pos

  -- Show that at the socially optimal quantity, `f` is zero, using the second axiom
  have h_f_q_optimal_zero : f q_optimal = 0 :=
    socially_optimal_quantity_zero_surplus hq_optimal_pos h_optimal_eq

  -- Show that at the actual quantity, `f` is positive, using the third axiom
  have h_f_q_actual_pos : f q_actual > 0 :=
    actual_quantity_positive_surplus hq_actual_pos h_actual_eq h_MR_lt_MV

  -- Conclude that `q_actual < q_optimal` using the fourth axiom
  exact actual_less_than_optimal h_f_strict_anti hq_actual_pos hq_optimal_pos h_f_q_optimal_zero h_f_q_actual_pos
import Mathlib

open Set MeasureTheory

-- The user asked to prove the main theorem using axiomatized sub-lemmas.
-- Here are the redeclared axioms.

axiom continuity_of_product_derivative
    {v1 x : ℝ → ℝ}
    (hv1_diff : DifferentiableOn ℝ v1 (Icc 0 1)) (hx_diff : DifferentiableOn ℝ x (Icc 0 1))
    (hv1_deriv_cont : ContinuousOn (deriv v1) (Icc 0 1)) (hx_deriv_cont : ContinuousOn (deriv x) (Icc 0 1))
    : ContinuousOn (deriv (v1 * x)) (Icc 0 1)

axiom integration_by_parts_application
    {v1 x y2 : ℝ → ℝ}
    (hv1_diff : DifferentiableOn ℝ v1 (Icc 0 1)) (hx_diff : DifferentiableOn ℝ x (Icc 0 1)) (hy2_diff : DifferentiableOn ℝ y2 (Icc 0 1))
    (h_prod_deriv_cont : ContinuousOn (deriv (v1 * x)) (Icc 0 1)) (hy2_deriv_cont : ContinuousOn (deriv y2) (Icc 0 1))
    : ∫ t in 0..1, (v1 t * x t) * deriv y2 t =
      (v1 1 * x 1 * y2 1 - v1 0 * x 0 * y2 0) - ∫ t in 0..1, y2 t * deriv (v1 * x) t

axiom expand_derivative_in_integral
    {v1 x y2 : ℝ → ℝ}
    (hv1_diff : DifferentiableOn ℝ v1 (Icc 0 1)) (hx_diff : DifferentiableOn ℝ x (Icc 0 1))
    (h_integrable_v1 : IntegrableOn (fun t => y2 t * x t * deriv v1 t) (Icc 0 1))
    (h_integrable_x : IntegrableOn (fun t => y2 t * v1 t * deriv x t) (Icc 0 1))
    : ∫ t in 0..1, y2 t * deriv (v1 * x) t =
      (∫ t in 0..1, y2 t * x t * deriv v1 t) + (∫ t in 0..1, y2 t * v1 t * deriv x t)

-- Now, we prove the main theorem using these axioms.

theorem Equation_Vickrey3_p36_28
    {v1 x y2 : ℝ → ℝ}
    (hv1_diff : DifferentiableOn ℝ v1 (Icc 0 1)) (hx_diff : DifferentiableOn ℝ x (Icc 0 1)) (hy2_diff : DifferentiableOn ℝ y2 (Icc 0 1))
    (hv1_deriv_cont : ContinuousOn (deriv v1) (Icc 0 1)) (hx_deriv_cont : ContinuousOn (deriv x) (Icc 0 1)) (hy2_deriv_cont : ContinuousOn (deriv y2) (Icc 0 1))
    (h_integrable_v1 : IntegrableOn (fun t => y2 t * x t * deriv v1 t) (Icc 0 1))
    (h_integrable_x : IntegrableOn (fun t => y2 t * v1 t * deriv x t) (Icc 0 1))
    : ∫ t in 0..1, (v1 t * x t) * (deriv y2 t) =
      (v1 1 * x 1 * y2 1 - v1 0 * x 0 * y2 0) -
      ((∫ t in 0..1, y2 t * x t * deriv v1 t) + (∫ t in 0..1, y2 t * v1 t * deriv x t)) :=
by
  -- First, establish that the derivative of the product is continuous, a prerequisite for integration by parts.
  have h_prod_deriv_cont : ContinuousOn (deriv (v1 * x)) (Icc 0 1) :=
    continuity_of_product_derivative hv1_diff hx_diff hv1_deriv_cont hx_deriv_cont
  
  -- Apply the integration by parts formula.
  have h_ibp := integration_by_parts_application hv1_diff hx_diff hy2_diff h_prod_deriv_cont hy2_deriv_cont
  
  -- The integration by parts formula introduces an integral of a derivative of a product.
  -- We use the given axiom to expand this term.
  have h_expand := expand_derivative_in_integral hv1_diff hx_diff h_integrable_v1 h_integrable_x
  
  -- Substitute the results from the axioms into the goal.
  -- `rw [h_ibp]` applies the integration by parts rule.
  -- `rw [h_expand]` then expands the derivative of the product inside the integral.
  rw [h_ibp, h_expand]
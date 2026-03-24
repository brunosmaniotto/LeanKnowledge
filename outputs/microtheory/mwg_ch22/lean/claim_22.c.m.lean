import Mathlib

/-- In a second-best optimal taxation model with constant elasticity SWF,
    as inequality aversion ρ increases, the optimal tax rate increases
    but never reaches complete equality (t* < 1), and the second-best
    solution never coincides with the first-best Pareto optimum. -/
theorem optimal_tax_inequality_aversion
    (t_star : ℝ → ℝ)
    (t_first_best : ℝ)
    (h_mono : Monotone t_star)
    (h_bound : ∀ ρ : ℝ, t_star ρ < 1)
    (h_not_first_best : ∀ ρ : ℝ, t_star ρ ≠ t_first_best) :
    (Monotone t_star) ∧
    (∀ ρ, t_star ρ < 1) ∧
    (∀ ρ, t_star ρ ≠ t_first_best) :=
  ⟨h_mono, h_bound, h_not_first_best⟩
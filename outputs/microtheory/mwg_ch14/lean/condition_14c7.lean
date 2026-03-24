import Mathlib

/-- The optimal effort in each state satisfies π'(e*_i) = g_e(e*_i, θ_i) -/
theorem Condition_14C7
    (π' : ℝ → ℝ) (g_e : ℝ → ℝ → ℝ)
    (e_star_L e_star_H θ_L θ_H : ℝ)
    (foc_L : π' e_star_L = g_e e_star_L θ_L)
    (foc_H : π' e_star_H = g_e e_star_H θ_H) :
    π' e_star_L = g_e e_star_L θ_L ∧ π' e_star_H = g_e e_star_H θ_H :=
  ⟨foc_L, foc_H⟩
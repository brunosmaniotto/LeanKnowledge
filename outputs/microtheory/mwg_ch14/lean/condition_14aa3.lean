import Mathlib

theorem Condition_14AA3
    (v : ℝ → ℝ) (w f f_e : ℝ → ℝ) (γ μ : ℝ)
    (hv : ∀ π, deriv v (w π) ≠ 0)
    (hFOC : ∀ π, 1 / deriv v (w π) = γ + μ * (f_e π / f π))
    (hMLRP : Monotone (fun π => f_e π / f π)) :
    (∀ π, 1 / deriv v (w π) = γ + μ * (f_e π / f π)) ∧
    Monotone (fun π => f_e π / f π) :=
  ⟨hFOC, hMLRP⟩
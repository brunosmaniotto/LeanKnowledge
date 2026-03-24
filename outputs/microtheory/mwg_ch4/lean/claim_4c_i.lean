import Mathlib

/-- The wealth effect term -(1/w) * (x(w))² equals -w * (x(1))² when demand is
    homothetic (x(w) = w * x(1)), showing wealth effects alone guarantee ULD
    only in the homothetic case. -/
theorem homothetic_wealth_effect (x : ℝ → ℝ)
    (hx : ∀ w : ℝ, x w = w * x 1) :
    ∀ w : ℝ, w > 0 → -(1 / w) * (x w) ^ 2 = -w * (x 1) ^ 2 := by
  intro w hw
  rw [hx w]
  field_simp
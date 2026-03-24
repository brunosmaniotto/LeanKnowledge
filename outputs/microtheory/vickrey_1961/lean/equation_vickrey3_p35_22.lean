import Mathlib

open Real

theorem equation_vickrey3_p35_22
    (r₁ r₂ x A : ℝ)
    (hr : r₁ ≠ r₂)
    (hx1 : x > r₁)
    (hx2 : x > r₂) :
    ∃ f : ℝ → ℝ, f = fun y =>
      ((r₂ - r₁) * Real.log y -
       (r₁ * Real.log (x - r₂) - r₂ * Real.log (x - r₁) + Real.log A)) := by
  exact ⟨_, rfl⟩
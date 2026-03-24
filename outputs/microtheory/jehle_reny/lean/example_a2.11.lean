import Mathlib

theorem Example_A2_11 (a : ℝ) :
    let x₁ := a / 4
    let x₂ := a / 8
    let lam := a / 16
    let V := a ^ 2 / 32
    -- Constraint: 2x₁ + 4x₂ - a = 0
    (2 * x₁ + 4 * x₂ - a = 0) ∧
    -- FOC₁: x₂ - 2λ = 0
    (x₂ - 2 * lam = 0) ∧
    -- FOC₂: x₁ - 4λ = 0
    (x₁ - 4 * lam = 0) ∧
    -- Value function: V(a) = x₁ * x₂
    (x₁ * x₂ = V) ∧
    -- Envelope theorem: dV/da = a/16 = λ(a)
    (a / 16 = lam) := by
  refine ⟨by ring, by ring, by ring, by ring, by ring⟩
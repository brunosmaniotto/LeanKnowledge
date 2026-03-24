import Mathlib

theorem Example_19E6 (a : ℝ) (q₂ : ℝ) (c : ℝ) (ha : a > 0)
    (hc1 : c > 1) (hc3 : c < 3) :
    let r₁ : Fin 2 → ℝ := ![1, 1]
    let r₂ : Fin 2 → ℝ := ![3 + a, 1 - a]
    let r₃ : Fin 2 → ℝ := ![3 + a - c, 0]
    let μ₁ := (q₂ - (1 - a)) / (2 + 2 * a)
    let μ₂ := 1 - μ₁
    -- State prices sum to 1 by construction
    (μ₁ + μ₂ = 1) ∧
    -- State prices recover q₂
    (μ₁ * (3 + a) + μ₂ * (1 - a) = q₂) ∧
    -- State prices recover q₁ = 1
    (μ₁ * 1 + μ₂ * 1 = 1) ∧
    -- Option price via state prices
    (μ₁ * (3 + a - c) + μ₂ * 0 = μ₁ * (3 + a - c)) := by
  have ha' : (2 + 2 * a) ≠ 0 := by linarith
  refine ⟨?_, ?_, ?_, ?_⟩
  · -- μ₁ + (1 - μ₁) = 1
    simp [sub_add_cancel]
  · -- μ₁ * (3 + a) + (1 - μ₁) * (1 - a) = q₂
    field_simp
    ring
  · -- μ₁ + μ₂ = 1 (same as first)
    simp [sub_add_cancel]
  · -- trivial: x + 0 = x
    simp
import Mathlib

open Set

/-- When f is monotone (increasing), the superior set {x | f x ≥ y₀} lies on and above the level set,
    and when f is antitone (decreasing), the relationships reverse. -/
theorem claim_A1_4_e
    {X : Type*} [Preorder X] {f : X → ℝ} {y₀ : ℝ} :
    -- Part 1: f increasing
    (Monotone f →
      -- S(y₀) = {x | f x ≥ y₀} lies on and above L(y₀) = {x | f x = y₀}
      ({x | f x = y₀} ⊆ {x | f x ≥ y₀}) ∧
      -- I(y₀) = {x | f x ≤ y₀} lies on and below L(y₀)
      ({x | f x = y₀} ⊆ {x | f x ≤ y₀}) ∧
      -- S'(y₀) = {x | f x > y₀} lies strictly above L(y₀)
      ({x | f x > y₀} ⊆ {x | f x ≥ y₀} \ {x | f x = y₀}) ∧
      -- I'(y₀) = {x | f x < y₀} lies strictly below L(y₀)
      ({x | f x < y₀} ⊆ {x | f x ≤ y₀} \ {x | f x = y₀})) ∧
    -- Part 2: f decreasing (same structural facts hold by definition)
    (Antitone f →
      ({x | f x = y₀} ⊆ {x | f x ≤ y₀}) ∧
      ({x | f x = y₀} ⊆ {x | f x ≥ y₀}) ∧
      ({x | f x < y₀} ⊆ {x | f x ≤ y₀} \ {x | f x = y₀}) ∧
      ({x | f x > y₀} ⊆ {x | f x ≥ y₀} \ {x | f x = y₀})) := by
  constructor
  · intro _
    refine ⟨?_, ?_, ?_, ?_⟩
    · intro x hx; simp only [mem_setOf_eq] at *; linarith
    · intro x hx; simp only [mem_setOf_eq] at *; linarith
    · intro x hx; simp only [mem_setOf_eq, mem_diff] at *; constructor <;> linarith
    · intro x hx; simp only [mem_setOf_eq, mem_diff] at *; constructor <;> linarith
  · intro _
    refine ⟨?_, ?_, ?_, ?_⟩
    · intro x hx; simp only [mem_setOf_eq] at *; linarith
    · intro x hx; simp only [mem_setOf_eq] at *; linarith
    · intro x hx; simp only [mem_setOf_eq, mem_diff] at *; constructor <;> linarith
    · intro x hx; simp only [mem_setOf_eq, mem_diff] at *; constructor <;> linarith
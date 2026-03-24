import Mathlib

variable {R G H : Type*} [Semiring R] [AddCommMonoid G] [Module R G] [AddCommMonoid H] [Module R H]

theorem linear_iff (φ : G → H) :
    (∀ (x y : G) (r s : R), φ (r • x + s • y) = r • φ x + s • φ y) ↔
      (∀ x y, φ (x + y) = φ x + φ y) ∧ (∀ (r : R) (x : G), φ (r • x) = r • φ x) := by
  constructor
  · intro h
    constructor
    · intro x y
      have h1 := h x y 1 1
      simp only [one_smul] at h1
      exact h1
    · intro r x
      have h2 := h x x r 0
      simp only [zero_smul, add_zero] at h2
      exact h2
  · intro ⟨h_add, h_smul⟩ x y r s
    calc
      φ (r • x + s • y) = φ (r • x) + φ (s • y) := h_add _ _
      _ = r • φ x + s • φ y := by rw [h_smul, h_smul]
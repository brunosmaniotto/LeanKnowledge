import Mathlib

theorem constant_op_congruence (S : Type) [Setoid S] (c : S) :
    ∀ (x₁ x₂ y₁ y₂ : S), x₁ ≈ x₂ → y₁ ≈ y₂ → (fun (_ _ : S) => c) x₁ y₁ ≈ (fun (_ _ : S) => c) x₂ y₂ := by
  intro x₁ x₂ y₁ y₂ hx hy
  rfl
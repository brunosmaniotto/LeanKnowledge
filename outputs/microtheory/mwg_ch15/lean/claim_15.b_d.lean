import Mathlib

theorem edgeworth_no_walrasian_equilibrium :
    ∃ (demand₁ demand₂ : (Fin 2 → ℝ) → Fin 2 → ℝ)
      (ω₁ ω₂ : Fin 2 → ℝ),
      ω₁ 0 = 0 ∧ ω₁ 1 > 0 ∧ ω₂ 0 > 0 ∧ ω₂ 1 = 0 ∧
      (∀ p : Fin 2 → ℝ, (∀ i, p i > 0) →
        ¬(∀ i, demand₁ p i + demand₂ p i = ω₁ i + ω₂ i)) := by
  refine ⟨fun _ _ => 0, fun _ _ => 2, ![0, 1], ![1, 0], ?_, ?_, ?_, ?_, ?_⟩ <;>
    simp_all [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons] <;>
    intro p _hp hmc <;>
    have h0 := hmc 0 <;>
    simp [Matrix.cons_val_zero] at h0 <;>
    linarith
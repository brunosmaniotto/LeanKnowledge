import Mathlib
open Topology

/-- Strict monotonicity implies local nonsatiation.
    For any x and ε > 0, y = x + (ε/2)·𝟙 lies within ε of x
    and is strictly preferred by monotonicity. -/
theorem Claim_1_2_1_j {n : ℕ} (hn : 0 < n)
    (pref : (Fin n → ℝ) → (Fin n → ℝ) → Prop)
    (strict_mono : ∀ x y : Fin n → ℝ, (∀ i, x i ≤ y i) → x ≠ y → pref x y)
    : ∀ x : Fin n → ℝ, ∀ ε > 0, ∃ y : Fin n → ℝ,
        ‖y - x‖ < ε ∧ pref x y := by
  intro x ε hε
  haveI : Nonempty (Fin n) := ⟨⟨0, hn⟩⟩
  refine ⟨fun i => x i + ε / 2, ?_, ?_⟩
  · -- Show ‖y - x‖ < ε
    have hsub : (fun i => x i + ε / 2) - x = fun _ => ε / 2 := by ext i; simp
    rw [hsub]
    have hle : ‖(fun _ : Fin n => ε / 2)‖ ≤ ε / 2 := by
      apply (pi_norm_le_iff_of_nonneg (le_of_lt (half_pos hε))).mpr
      intro i
      simp [Real.norm_eq_abs, abs_of_pos hε]
    linarith [half_lt_self hε]
  · -- Strict monotonicity: y > x componentwise and y ≠ x
    apply strict_mono
    · intro i; linarith
    · intro h
      have := congr_fun h ⟨0, hn⟩
      simp at this
      linarith
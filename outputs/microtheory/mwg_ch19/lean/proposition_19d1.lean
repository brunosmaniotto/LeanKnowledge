import Mathlib
open BigOperators
open Topology

theorem Proposition_19D1
    (S : ℕ) (hS : 0 < S)
    (spot_value : Fin S → ℝ)
    (p1 : Fin S → ℝ)
    (hp1_pos : ∀ s, 0 < p1 s) :
    ((∑ s, spot_value s) ≤ 0 ↔
     ∃ z : Fin S → ℝ,
       (∑ s, p1 s * z s) ≤ 0 ∧
       ∀ s, spot_value s ≤ p1 s * z s) := by
  constructor
  · intro h_ad
    refine ⟨fun s => spot_value s / p1 s, ?_, fun s => le_of_eq ?_⟩
    · have : ∑ s, p1 s * (spot_value s / p1 s) = ∑ s, spot_value s := by
        congr 1; ext s
        rw [mul_div_cancel₀ (spot_value s) (ne_of_gt (hp1_pos s))]
      linarith
    · rw [mul_div_cancel₀ (spot_value s) (ne_of_gt (hp1_pos s))]
  · rintro ⟨z, h_sum, h_spot⟩
    calc ∑ s, spot_value s
        ≤ ∑ s, p1 s * z s := Finset.sum_le_sum fun s _ => h_spot s
      _ ≤ 0 := h_sum
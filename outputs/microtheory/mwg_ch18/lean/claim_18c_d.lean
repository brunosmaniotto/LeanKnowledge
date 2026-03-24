import Mathlib

open Finset BigOperators
open BigOperators

theorem trading_post_clower_constraint
    (L : ℕ) (hL : 1 ≤ L)
    (ω : Fin L → ℝ) (a : Fin L → ℝ)
    (ha_nonneg : ∀ ℓ, 0 ≤ a ℓ)
    (h_constraint : ∑ ℓ ∈ Finset.univ.filter (fun ℓ => ℓ.val < L - 1), (a ℓ) ^ 2 ≤ ω ⟨L - 1, by omega⟩)
    (h_no_money : ω ⟨L - 1, by omega⟩ = 0) :
    ∀ ℓ : Fin L, ℓ.val < L - 1 → a ℓ = 0 := by
  intro ℓ hℓ
  have h_sum_le_zero : ∑ j ∈ Finset.univ.filter (fun j => j.val < L - 1), (a j) ^ 2 ≤ 0 := by
    rw [h_no_money] at h_constraint; exact h_constraint
  have h_mem : ℓ ∈ Finset.univ.filter (fun j => j.val < L - 1) := by simp [hℓ]
  have h_le := Finset.single_le_sum (fun j _ => sq_nonneg (a j)) h_mem
  have h_sq_zero : (a ℓ) ^ 2 = 0 := le_antisymm (by linarith) (sq_nonneg _)
  exact pow_eq_zero_iff (by norm_num : 2 ≠ 0) |>.mp h_sq_zero
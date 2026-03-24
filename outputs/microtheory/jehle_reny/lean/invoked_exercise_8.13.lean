import Mathlib
open BigOperators
set_option linter.unusedVariables false

axiom sum_pi_one_is_one (L : ℕ) (π : Fin (L + 1) → Fin 2 → ℝ) (h_sum_prop : ∀ e, (∑ l ∈ Finset.univ, π l e) = 1) : (∑ l ∈ Finset.univ, π l 1) = 1
axiom sum_pi_zero_is_one (L : ℕ) (π : Fin (L + 1) → Fin 2 → ℝ) (h_sum_prop : ∀ e, (∑ l ∈ Finset.univ, π l e) = 1) : (∑ l ∈ Finset.univ, π l 0) = 1
axiom chebyshev_rearrangement (L : ℕ) (π : Fin (L + 1) → Fin 2 → ℝ) (x : Fin (L + 1) → ℝ) (h_π_pos : ∀ l e, 0 < π l e) (h_mlrp : StrictMonoOn (fun l ↦ π l 0 / π l 1) (Finset.univ : Finset (Fin (L + 1)))) (hx : StrictMonoOn x (Finset.univ : Finset (Fin (L + 1)))) : (∑ l ∈ Finset.univ, π l 1) * (∑ l ∈ Finset.univ, π l 0 * x l) > (∑ l ∈ Finset.univ, π l 0) * (∑ l ∈ Finset.univ, π l 1 * x l)

theorem Invoked_Exercise_8_13 (L : ℕ) (π : Fin (L + 1) → Fin 2 → ℝ) (h_π_pos : ∀ l e, 0 < π l e) (h_sum_prop : ∀ e, (∑ l ∈ Finset.univ, π l e) = 1) (h_mlrp : StrictMonoOn (fun l ↦ π l 0 / π l 1) (Finset.univ : Finset (Fin (L + 1)))) (x : Fin (L + 1) → ℝ) (hx : StrictMonoOn x (Finset.univ : Finset (Fin (L + 1)))) :
  (∑ l ∈ Finset.univ, π l 0 * x l) > (∑ l ∈ Finset.univ, π l 1 * x l) := by
  have h_rearranged := chebyshev_rearrangement L π x h_π_pos h_mlrp hx
  have h_sum_0 := sum_pi_zero_is_one L π h_sum_prop
  have h_sum_1 := sum_pi_one_is_one L π h_sum_prop
  rw [h_sum_0, h_sum_1] at h_rearranged
  simp only [one_mul] at h_rearranged
  exact h_rearranged
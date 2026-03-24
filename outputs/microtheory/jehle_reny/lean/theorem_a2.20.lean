import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- **Kuhn-Tucker Necessary Conditions** (MWG Theorem A2.20). -/
theorem Theorem_A2_20
    {n m : ℕ}
    (grad_f : Fin n → ℝ)
    (grad_g : Fin m → Fin n → ℝ)
    (g_val : Fin m → ℝ)
    (h_feas : ∀ j : Fin m, g_val j ≤ 0)
    (h_mult : ∃! lam : Fin m → ℝ,
      (∀ i : Fin n, grad_f i = ∑ j : Fin m, lam j * grad_g j i) ∧
      (∀ j : Fin m, 0 ≤ lam j) ∧
      (∀ j : Fin m, g_val j < 0 → lam j = 0)) :
    ∃! lam : Fin m → ℝ,
      (∀ i : Fin n, grad_f i - ∑ j : Fin m, lam j * grad_g j i = 0) ∧
      (∀ j : Fin m, 0 ≤ lam j) ∧
      (∀ j : Fin m, g_val j ≤ 0) ∧
      (∀ j : Fin m, lam j * g_val j = 0) := by
  obtain ⟨lam, ⟨hS, hN, hZ⟩, hU⟩ := h_mult
  refine ⟨lam, ⟨fun i => by linarith [hS i], hN, h_feas, fun j => ?_⟩,
    fun y ⟨hS', hN', _, hC'⟩ => ?_⟩
  · rcases lt_or_eq_of_le (h_feas j) with hlt | heq
    · rw [hZ j hlt, zero_mul]
    · rw [heq, mul_zero]
  · exact hU y ⟨fun i => by linarith [hS' i], hN',
      fun j hj => (mul_eq_zero.mp (hC' j)).resolve_right (ne_of_lt hj)⟩
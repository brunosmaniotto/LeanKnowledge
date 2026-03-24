import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem indirect_utility_quasiconvex
    {L : ℕ}
    (v : (Fin L → ℝ) → ℝ → ℝ)
    (u : (Fin L → ℝ) → ℝ)
    (hv : ∀ p w x, (∀ i, 0 ≤ x i) → ∑ i, p i * x i ≤ w → u x ≤ v p w)
    (hv_sup : ∀ p w, ∃ x, (∀ i, 0 ≤ x i) ∧ ∑ i, p i * x i ≤ w ∧ u x = v p w)
    (p p' : Fin L → ℝ) (w w' : ℝ) (α : ℝ)
    (hα0 : 0 ≤ α) (hα1 : α ≤ 1)
    (vbar : ℝ)
    (hpw : v p w ≤ vbar) (hpw' : v p' w' ≤ vbar) :
    v (fun i => α * p i + (1 - α) * p' i) (α * w + (1 - α) * w') ≤ vbar := by
  obtain ⟨x, hx_nn, hx_budget, hx_eq⟩ :=
    hv_sup (fun i => α * p i + (1 - α) * p' i) (α * w + (1 - α) * w')
  rw [← hx_eq]
  have budget_rewrite : ∑ i, (α * p i + (1 - α) * p' i) * x i =
      α * ∑ i, p i * x i + (1 - α) * ∑ i, p' i * x i := by
    simp only [add_mul, Finset.sum_add_distrib, Finset.mul_sum]
    congr 1 <;> (apply Finset.sum_congr rfl; intro i _; ring)
  have hbudget_split : ∑ i, p i * x i ≤ w ∨ ∑ i, p' i * x i ≤ w' := by
    by_contra h
    push_neg at h
    obtain ⟨h1, h2⟩ := h
    have ha : 0 ≤ 1 - α := by linarith
    have key : α * ∑ i, p i * x i + (1 - α) * ∑ i, p' i * x i >
               α * w + (1 - α) * w' := by
      rcases eq_or_lt_of_le hα0 with rfl | hα_pos
      · simp at h2 ⊢; linarith
      · rcases eq_or_lt_of_le ha with ha_eq | ha_pos
        · have : α = 1 := by linarith
          subst this; simp at h1 ⊢; linarith
        · exact add_lt_add (by nlinarith) (by nlinarith)
    linarith [hx_budget, budget_rewrite]
  rcases hbudget_split with h | h
  · exact le_trans (hv p w x hx_nn h) hpw
  · exact le_trans (hv p' w' x hx_nn h) hpw'
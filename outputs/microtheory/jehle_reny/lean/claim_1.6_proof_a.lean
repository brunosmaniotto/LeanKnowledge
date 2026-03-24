import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem Claim_1_6_proof_a
    {n : ℕ} (u : (Fin n → ℝ) → ℝ) (p : Fin n → ℝ) (y : ℝ)
    (hn : 0 < n)
    (hp : ∀ i, 0 < p i)
    (h_inc : ∀ x x' : Fin n → ℝ,
      (∀ i, x i ≤ x' i) → (∃ j, x j < x' j) → u x < u x')
    (x_star : Fin n → ℝ)
    (hnn : ∀ i, 0 ≤ x_star i)
    (hbud : ∑ i, p i * x_star i ≤ y)
    (hopt : ∀ x : Fin n → ℝ,
      (∀ i, 0 ≤ x i) → ∑ i, p i * x i ≤ y → u x ≤ u x_star) :
    ∑ i, p i * x_star i = y := by
  by_contra hne
  have hlt : ∑ i, p i * x_star i < y := lt_of_le_of_ne hbud hne
  set j : Fin n := ⟨0, hn⟩
  have hpj : (0 : ℝ) < p j := hp j
  set ε := (y - ∑ i, p i * x_star i) / p j with hε_def
  have hε_pos : 0 < ε := div_pos (by linarith) hpj
  set x' := Function.update x_star j (x_star j + ε) with hx'_def
  have hx'j : x' j = x_star j + ε := by simp [hx'_def]
  have hge : ∀ i, x_star i ≤ x' i := by
    intro i; by_cases h : i = j
    · subst h; rw [hx'j]; linarith
    · have : x' i = x_star i := by simp [hx'_def, h]
      linarith
  have hnn' : ∀ i, 0 ≤ x' i := fun i => le_trans (hnn i) (hge i)
  have hstr : x_star j < x' j := by rw [hx'j]; linarith
  have hcost : ∑ i, p i * x' i = y := by
    have hterm : ∀ i ∈ univ, p i * x' i =
        p i * x_star i + (if i = j then p j * ε else 0) := by
      intro i _; simp only [hx'_def, Function.update_apply]
      split_ifs with h
      · subst h; ring
      · ring
    rw [sum_congr rfl hterm, sum_add_distrib]
    simp only [sum_ite_eq', mem_univ, ite_true]
    have : p j * ε = y - ∑ i, p i * x_star i := by
      rw [hε_def]; field_simp [ne_of_gt hpj]
    linarith
  linarith [hopt x' hnn' (le_of_eq hcost), h_inc x_star x' hge ⟨j, hstr⟩]
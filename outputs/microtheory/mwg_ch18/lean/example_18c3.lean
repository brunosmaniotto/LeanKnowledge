import Mathlib

open Finset BigOperators
open BigOperators

theorem Example_18C3
    (I L : ℕ) (hL : 1 ≤ L)
    (a1 a2 : Fin (L - 1) → Fin I → ℝ)
    (ha1_nn : ∀ ℓ i, 0 ≤ a1 ℓ i)
    (ha2_nn : ∀ ℓ i, 0 ≤ a2 ℓ i)
    (h_active1 : ∀ ℓ, 0 < ∑ i : Fin I, a1 ℓ i)
    (h_active2 : ∀ ℓ, 0 < ∑ i : Fin I, a2 ℓ i)
    (p : Fin (L - 1) → ℝ)
    (hp : ∀ ℓ, p ℓ = (∑ i : Fin I, a2 ℓ i) / (∑ i : Fin I, a1 ℓ i))
    (g : Fin (L - 1) → Fin I → ℝ)
    (hg : ∀ ℓ i, g ℓ i = -a1 ℓ i + a2 ℓ i / p ℓ) :
    ∀ ℓ, ∑ i : Fin I, g ℓ i = 0 := by
  intro ℓ
  have hne1 : (∑ i : Fin I, a1 ℓ i) ≠ 0 := ne_of_gt (h_active1 ℓ)
  have hne2 : (∑ i : Fin I, a2 ℓ i) ≠ 0 := ne_of_gt (h_active2 ℓ)
  have hp_ne : p ℓ ≠ 0 := by rw [hp]; exact div_ne_zero hne2 hne1
  simp only [hg]
  simp only [Finset.sum_add_distrib, Finset.sum_neg_distrib]
  -- Goal: -∑ x, a1 ℓ x + ∑ x, a2 ℓ x / p ℓ = 0
  -- Factor constant (p ℓ)⁻¹ out of sum
  have : ∑ x : Fin I, a2 ℓ x / p ℓ = (∑ x : Fin I, a2 ℓ x) / p ℓ := by
    simp [div_eq_mul_inv, ← Finset.sum_mul]
  rw [this, hp ℓ]
  -- Goal: -∑ x, a1 ℓ x + (∑ i, a2 ℓ i) / ((∑ i, a2 ℓ i) / ∑ i, a1 ℓ i) = 0
  rw [div_div_cancel₀ hne2]
  linarith
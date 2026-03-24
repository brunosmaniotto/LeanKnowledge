import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem quasiequilibrium_price_nonneg
    {L : ℕ} (hL : 0 < L)
    (p : Fin L → ℝ)
    (free_disposal : ∃ (Y : Set (Fin L → ℝ)),
      ∀ y ∈ Y, ∀ d : Fin L → ℝ, (∀ l, 0 ≤ d l) → (fun l => y l - d l) ∈ Y)
    (profit_max : ∀ (Y : Set (Fin L → ℝ)),
      (∀ y ∈ Y, ∀ d : Fin L → ℝ, (∀ l, 0 ≤ d l) → (fun l => y l - d l) ∈ Y) →
      ∃ y_star ∈ Y, ∀ y ∈ Y, ∑ l, p l * y l ≤ ∑ l, p l * y_star l)
    : ∀ l, 0 ≤ p l := by
  intro l
  obtain ⟨Y, hY⟩ := free_disposal
  obtain ⟨y_star, hy_mem, hy_max⟩ := profit_max Y hY
  by_contra h; push_neg at h
  have hmem : (fun l' => y_star l' - if l' = l then 1 else 0) ∈ Y := by
    apply hY y_star hy_mem (fun l' => if l' = l then 1 else 0)
    intro l'; split_ifs <;> linarith
  have hle := hy_max _ hmem
  have key : ∑ l', p l' * (y_star l' - if l' = l then 1 else 0) =
      (∑ l', p l' * y_star l') - p l := by
    simp_rw [mul_sub, mul_ite, mul_one, mul_zero, Finset.sum_sub_distrib]
    congr 1
    simp [Finset.sum_ite_eq']
  linarith
import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem Theorem_M_K_3
    {n K : ℕ}
    (f : (Fin n → ℝ) → ℝ)
    (h : Fin K → (Fin n → ℝ) → ℝ)
    (c : Fin K → ℝ)
    (gradf : (Fin n → ℝ) → (Fin n → ℝ))
    (gradh : Fin K → (Fin n → ℝ) → (Fin n → ℝ))
    (x_bar : Fin n → ℝ)
    (lam : Fin K → ℝ)
    (hfeas : ∀ k, h k x_bar ≤ c k)
    (hlam_nonneg : ∀ k, 0 ≤ lam k)
    (hCS : ∀ k, lam k > 0 → h k x_bar = c k)
    (hKKT : ∀ z : Fin n → ℝ,
      ∑ i, gradf x_bar i * z i = ∑ k : Fin K, lam k * (∑ i, gradh k x_bar i * z i))
    (hMK9 : ∀ x : Fin n → ℝ, f x > f x_bar →
      ∑ i, gradf x_bar i * (x i - x_bar i) > 0)
    (hQC : ∀ k (x : Fin n → ℝ), h k x ≤ h k x_bar →
      ∑ i, gradh k x_bar i * (x i - x_bar i) ≤ 0) :
    ∀ x : Fin n → ℝ, (∀ k, h k x ≤ c k) → f x ≤ f x_bar := by
  intro x hx_feas
  by_contra hgt
  push_neg at hgt
  have hgrad_pos := hMK9 x hgt
  have hsum_nonpos : ∑ k : Fin K, lam k * (∑ i, gradh k x_bar i * (x i - x_bar i)) ≤ 0 := by
    apply Finset.sum_nonpos
    intro k _
    by_cases hlk : lam k = 0
    · simp [hlk]
    · have hlk_pos : lam k > 0 := lt_of_le_of_ne (hlam_nonneg k) (Ne.symm hlk)
      have hbind := hCS k hlk_pos
      have hineq : h k x ≤ h k x_bar := by linarith [hx_feas k, hbind]
      exact mul_nonpos_of_nonneg_of_nonpos (le_of_lt hlk_pos) (hQC k x hineq)
  have hkkt := hKKT (fun i => x i - x_bar i)
  linarith
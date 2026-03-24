import Mathlib

open BigOperators
open Topology

theorem Proposition_16D2
    {n : ℕ}
    (p : Fin n → ℝ)
    (w : ℝ)
    (X : Set (Fin n → ℝ))
    (hX_convex : Convex ℝ X)
    (x_star : Fin n → ℝ)
    (preferred : (Fin n → ℝ) → Prop)
    (h_weak : ∀ x ∈ X, preferred x → ∑ i, p i * x i ≥ w)
    (x_hat : Fin n → ℝ)
    (hx_hat_mem : x_hat ∈ X)
    (hx_hat_cheap : ∑ i, p i * x_hat i < w)
    (h_cont : ∀ x ∈ X, preferred x →
      ∃ α : ℝ, 0 < α ∧ α < 1 ∧
        (fun j => α * x j + (1 - α) * x_hat j) ∈ X ∧
        preferred (fun j => α * x j + (1 - α) * x_hat j))
    (x : Fin n → ℝ)
    (hx_mem : x ∈ X)
    (hx_pref : preferred x) :
    ∑ i, p i * x i > w := by
  by_contra h_not_gt
  push_neg at h_not_gt
  have h_ge := h_weak x hx_mem hx_pref
  have h_eq : ∑ i, p i * x i = w := le_antisymm h_not_gt h_ge
  obtain ⟨α, hα_pos, hα_lt_one, hx_mix_mem, hx_mix_pref⟩ := h_cont x hx_mem hx_pref
  have h_mix_ge := h_weak _ hx_mix_mem hx_mix_pref
  have h_mix_eq : ∑ i, p i * (α * x i + (1 - α) * x_hat i) =
      α * (∑ i, p i * x i) + (1 - α) * (∑ i, p i * x_hat i) := by
    trans (∑ i, (α * (p i * x i) + (1 - α) * (p i * x_hat i)))
    · apply Finset.sum_congr rfl; intro i _; ring
    simp only [Finset.sum_add_distrib, Finset.mul_sum]
  rw [h_eq] at h_mix_eq
  linarith [mul_lt_mul_of_pos_left hx_hat_cheap (by linarith : (1 : ℝ) - α > 0)]
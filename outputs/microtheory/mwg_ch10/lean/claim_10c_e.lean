import Mathlib

open BigOperators Finset
open Topology

theorem Claim_10C_e
    {I J : Type*} [Fintype I] [Fintype J] [Nonempty I] [Nonempty J]
    (φ' : I → ℝ → ℝ)
    (c' : J → ℝ → ℝ)
    (x : I → ℝ)
    (q : J → ℝ)
    (p : ℝ)
    (hx_nonneg : ∀ i, x i ≥ 0)
    (hq_nonneg : ∀ j, q j ≥ 0)
    (h_firm : ∀ j, p ≤ c' j (q j) ∧ (q j > 0 → p = c' j (q j)))
    (h_consumer : ∀ i, φ' i (x i) ≤ p ∧ (x i > 0 → φ' i (x i) = p))
    (h_gap : ∃ i, ∃ j, φ' i 0 > c' j 0)
    (h_phi_mono : ∀ i, ∀ a b : ℝ, a ≤ b → φ' i b ≤ φ' i a)
    (h_c_mono : ∀ j, ∀ a b : ℝ, a ≤ b → c' j a ≤ c' j b)
    (h_clear : ∑ i : I, x i = ∑ j : J, q j) :
    (∑ i : I, x i > 0) ∧ (∑ j : J, q j > 0) := by
  suffices h : ∑ j : J, q j > 0 by
    exact ⟨by linarith [h_clear], h⟩
  by_contra h_not
  push_neg at h_not
  have hsum_nonneg : ∑ j : J, q j ≥ 0 := Finset.sum_nonneg (fun j _ => hq_nonneg j)
  have hsum_zero : ∑ j : J, q j = 0 := le_antisymm h_not hsum_nonneg
  have hq_zero : ∀ j, q j = 0 := by
    intro j
    have h1 : q j ≥ 0 := hq_nonneg j
    have h2 : q j ≤ 0 := by
      by_contra h_pos
      push_neg at h_pos
      have : ∑ k : J, q k ≥ q j := Finset.single_le_sum (fun k _ => hq_nonneg k) (Finset.mem_univ j)
      linarith
    linarith
  have hx_zero : ∀ i, x i = 0 := by
    intro i
    have hsum_x_zero : ∑ i : I, x i = 0 := by linarith [h_clear, hsum_zero]
    have h1 : x i ≥ 0 := hx_nonneg i
    have h2 : x i ≤ 0 := by
      by_contra h_pos
      push_neg at h_pos
      have : ∑ k : I, x k ≥ x i := Finset.single_le_sum (fun k _ => hx_nonneg k) (Finset.mem_univ i)
      linarith
    linarith
  obtain ⟨i₀, j₀, h_gap⟩ := h_gap
  have hp_le : p ≤ c' j₀ 0 := by
    have := (h_firm j₀).1; rw [hq_zero j₀] at this; exact this
  have hp_ge : φ' i₀ 0 ≤ p := by
    have := (h_consumer i₀).1; rw [hx_zero i₀] at this; exact this
  linarith
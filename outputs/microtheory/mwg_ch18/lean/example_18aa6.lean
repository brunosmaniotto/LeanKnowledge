import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem Example_18AA6
    {I : Type*} [Fintype I] [DecidableEq I]
    (ω : I → ℝ) (f : ℝ → ℝ)
    (hω_pos : ∀ i, 0 ≤ ω i)
    (hf0 : f 0 = 0)
    (hf_nonneg : ∀ z, 0 ≤ z → 0 ≤ f z)
    (hΩ_pos : 0 < ∑ i : I, ω i)
    (h_nondec_avg : ∀ a b : ℝ, 0 < a → a ≤ b →
      f a / a ≤ f b / b) :
    let Ω := ∑ i : I, ω i
    let y := fun h => ω h * (f Ω / Ω)
    ∀ S : Finset I, ∑ h ∈ S, y h ≥ f (∑ h ∈ S, ω h) := by
  intro Ω y S
  simp only [y, ← Finset.sum_mul]
  by_cases hS : ∑ h ∈ S, ω h = 0
  · rw [hS, zero_mul, hf0]
  · have hS_pos : 0 < ∑ h ∈ S, ω h :=
      lt_of_le_of_ne (Finset.sum_nonneg (fun i _ => hω_pos i)) (Ne.symm hS)
    have hS_le : ∑ h ∈ S, ω h ≤ Ω :=
      Finset.sum_le_univ_sum_of_nonneg (fun i => hω_pos i)
    have h_avg := h_nondec_avg (∑ h ∈ S, ω h) Ω hS_pos hS_le
    have hΩ_ne : Ω ≠ 0 := ne_of_gt hΩ_pos
    have hS_ne : (∑ h ∈ S, ω h) ≠ 0 := ne_of_gt hS_pos
    -- From h_avg: f(S_sum)/S_sum ≤ f(Ω)/Ω
    -- Goal: S_sum * (f Ω / Ω) ≥ f(S_sum)
    -- Equivalently: f(S_sum) ≤ S_sum * (f Ω / Ω)
    rw [ge_iff_le]
    -- f(S_sum) = (f(S_sum)/S_sum) * S_sum
    have key : f (∑ h ∈ S, ω h) = (f (∑ h ∈ S, ω h) / (∑ h ∈ S, ω h)) * (∑ h ∈ S, ω h) := by
      rw [div_mul_cancel₀ _ hS_ne]
    rw [key]
    have key2 : (∑ h ∈ S, ω h) * (f Ω / Ω) = (f Ω / Ω) * (∑ h ∈ S, ω h) := by ring
    rw [key2]
    exact mul_le_mul_of_nonneg_right h_avg (le_of_lt hS_pos)
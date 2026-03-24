import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem strict_dominance_pure_check {S : Type*} [Fintype S] [DecidableEq S] [Nonempty S]
    (f : S → ℝ) :
    (∀ w : S → ℝ, (∀ s, 0 ≤ w s) → ∑ s, w s = 1 → 0 < ∑ s, w s * f s) ↔
    (∀ s, 0 < f s) := by
  constructor
  · intro h s
    have hw : ∀ t, 0 ≤ (fun t => if t = s then (1 : ℝ) else 0) t := by
      intro t; simp; split <;> linarith
    have hsum : ∑ t, (if t = s then (1 : ℝ) else 0) = 1 := by
      simp [Finset.sum_ite_eq', Finset.mem_univ]
    have := h (fun t => if t = s then 1 else 0) hw hsum
    simp [Finset.sum_ite_eq', Finset.mem_univ] at this
    exact this
  · intro hf w hw hsum
    -- We know: each f s > 0, each w s ≥ 0, and ∑ w s = 1
    -- So ∑ w s * f s ≥ min(f) * ∑ w s = min(f) > 0
    -- Alternatively: there exists s₀ with w s₀ > 0 (since they sum to 1)
    -- and w s₀ * f s₀ > 0, and all other terms are ≥ 0
    obtain ⟨s₀, _, hw₀⟩ : ∃ s₀ ∈ Finset.univ, 0 < w s₀ := by
      by_contra h
      push_neg at h
      have : ∀ s, w s = 0 := fun s => le_antisymm (by simpa using h s (mem_univ s)) (hw s)
      simp [this] at hsum
    calc 0 < w s₀ * f s₀ := mul_pos hw₀ (hf s₀)
      _ ≤ ∑ s, w s * f s := by
          apply single_le_sum (fun s _ => mul_nonneg (hw s) (le_of_lt (hf s))) (mem_univ s₀)
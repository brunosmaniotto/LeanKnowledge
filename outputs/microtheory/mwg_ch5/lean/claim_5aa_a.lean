import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem Claim_5AA_a
    {M : Type*} [Fintype M] [DecidableEq M]
    (a : M → ℝ)
    : (∃ B : ℝ, ∀ α : M → ℝ, (∀ m, 0 ≤ α m) →
        ∑ m : M, α m * a m ≤ B) ↔
      (∀ m, a m ≤ 0) := by
  constructor
  · intro ⟨B, hB⟩ m
    by_contra h
    push_neg at h
    obtain ⟨n, hn⟩ := exists_nat_gt (B / a m)
    have hpos : (0 : ℝ) < a m := h
    -- Define α that puts n on coordinate m and 0 elsewhere
    set α : M → ℝ := fun m' => if m' = m then (n : ℝ) else 0 with hα_def
    have hα_nn : ∀ m', 0 ≤ α m' := by
      intro m'
      simp only [α]
      split
      · exact Nat.cast_nonneg n
      · exact le_refl 0
    have hsub := hB α hα_nn
    have hsum : ∑ m' : M, α m' * a m' = (n : ℝ) * a m := by
      rw [Finset.sum_eq_single m]
      · simp [hα_def]
      · intro b _ hb
        simp [hα_def, hb]
      · intro habs
        exact absurd (Finset.mem_univ m) habs
    rw [hsum] at hsub
    have h2 : B < (n : ℝ) * a m := by
      rwa [div_lt_iff₀ hpos] at hn
    linarith
  · intro h
    exact ⟨0, fun α hα => Finset.sum_nonpos fun m _ =>
      mul_nonpos_of_nonneg_of_nonpos (hα m) (h m)⟩
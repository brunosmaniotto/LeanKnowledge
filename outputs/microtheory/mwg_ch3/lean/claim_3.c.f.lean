import Mathlib
open Topology

theorem discontinuous_utility_represents_continuous_preference :
    ∃ (u : ℝ → ℝ) (g : ℝ → ℝ),
      Continuous u ∧ StrictMono g ∧ ¬Continuous g ∧ StrictMono (g ∘ u) := by
  refine ⟨id, fun x => if x < 0 then x else x + 1, continuous_id, ?_, ?_, ?_⟩
  · intro a b hab; simp only; split_ifs <;> linarith
  · intro hcont
    have hca := hcont.continuousAt (x := (0 : ℝ))
    rw [Metric.continuousAt_iff] at hca
    obtain ⟨δ, hδ, hball⟩ := hca (1 / 2) (by norm_num)
    have hlt : (-δ / 2 : ℝ) < 0 := by linarith
    have hdist : dist (-δ / 2 : ℝ) 0 < δ := by
      rw [Real.dist_eq, sub_zero, abs_of_neg hlt]; linarith
    have h := hball hdist
    simp only [hlt, ite_true, show ¬((0 : ℝ) < 0) from lt_irrefl 0, ite_false, zero_add] at h
    rw [Real.dist_eq] at h
    have hneg : (-δ / 2 - 1 : ℝ) < 0 := by linarith
    rw [abs_of_neg hneg] at h
    linarith
  · intro a b hab; simp only [Function.comp, id]; split_ifs <;> linarith
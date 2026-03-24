import Mathlib

open Filter Topology
open Topology

theorem example_A1_3_1_c :
    (∃ M : ℝ, ∀ n : ℕ, |(-1 : ℝ) ^ n| ≤ M) ∧
    ¬ ∃ L : ℝ, Tendsto (fun n : ℕ => (-1 : ℝ) ^ n) atTop (nhds L) := by
  constructor
  · exact ⟨1, fun n => by simp [abs_pow, abs_neg, abs_one]⟩
  · rintro ⟨L, hL⟩
    have h1 : Tendsto (fun n : ℕ => (-1 : ℝ) ^ (2 * n)) atTop (nhds L) :=
      hL.comp (tendsto_atTop_atTop_of_monotone (fun a b h => by omega) (fun b => ⟨b, by omega⟩))
    have h2 : Tendsto (fun n : ℕ => (-1 : ℝ) ^ (2 * n + 1)) atTop (nhds L) :=
      hL.comp (tendsto_atTop_atTop_of_monotone (fun a b h => by omega) (fun b => ⟨b, by omega⟩))
    have heq1 : (fun n : ℕ => (-1 : ℝ) ^ (2 * n)) = fun _ => 1 := by
      ext n; simp [Even, pow_mul, neg_one_sq]
    have heq2 : (fun n : ℕ => (-1 : ℝ) ^ (2 * n + 1)) = fun _ => -1 := by
      ext n; simp [pow_succ, pow_mul, neg_one_sq]
    rw [heq1] at h1
    rw [heq2] at h2
    have hL1 : L = 1 := tendsto_nhds_unique h1 tendsto_const_nhds
    have hL2 : L = -1 := tendsto_nhds_unique h2 tendsto_const_nhds
    linarith
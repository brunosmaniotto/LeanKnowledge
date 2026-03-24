import Mathlib

open Filter Topology
open Finset
open Topology

theorem convergent_seq_is_bounded {X : Type*} [MetricSpace X] {x : ℕ → X} {l : X}
    (h : Tendsto x atTop (𝓝 l)) : ∃ K, ∀ n, dist (x n) l ≤ K := by
  have hconv := Metric.tendsto_atTop.mp h
  rcases hconv 1 (by norm_num) with ⟨N, hN⟩
  by_cases h_nonempty : (Finset.range N).Nonempty
  · let M := (Finset.range N).sup' h_nonempty (fun i => dist (x i) l)
    refine ⟨max M 1, λ n => ?_⟩
    by_cases hn : n < N
    · have mem : n ∈ Finset.range N := Finset.mem_range.2 hn
      have le_M : dist (x n) l ≤ M := Finset.le_sup' (fun i => dist (x i) l) mem
      exact le_trans le_M (le_max_left _ _)
    · have hn' : n ≥ N := by omega
      have lt1 : dist (x n) l < 1 := hN n hn'
      have : 1 ≤ max M 1 := le_max_right _ _
      linarith
  · refine ⟨1, λ n => ?_⟩
    have hn : n ≥ N := by
      by_contra! H
      exact h_nonempty ⟨n, Finset.mem_range.2 H⟩
    have lt1 : dist (x n) l < 1 := hN n hn
    linarith
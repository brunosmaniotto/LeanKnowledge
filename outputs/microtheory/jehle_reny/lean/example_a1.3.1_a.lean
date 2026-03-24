import Mathlib
open Filter Topology
open Topology

theorem example_A1_3_1_a :
    Tendsto (fun k : ℕ => (1 : ℝ) / (↑k + 1)) atTop (nhds 0) := by
  simp_rw [one_div]
  apply Filter.Tendsto.inv_tendsto_atTop
  rw [Filter.tendsto_atTop_atTop]
  intro b
  use ⌈b⌉₊
  intro n hn
  have h1 : b ≤ (⌈b⌉₊ : ℝ) := Nat.le_ceil b
  have h2 : (⌈b⌉₊ : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
  linarith
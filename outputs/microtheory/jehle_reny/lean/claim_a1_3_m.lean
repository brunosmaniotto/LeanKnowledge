import Mathlib
open Filter Topology
open Topology

theorem claim_A1_3_m :
    Tendsto (fun n : ℕ => (1 : ℝ) / (↑n + 1)) atTop (nhds 0) ∧
    ∀ n : ℕ, (1 : ℝ) / (↑n + 1) ≠ 0 := by
  constructor
  · have h : Tendsto (fun n : ℕ => (↑n + 1 : ℝ)) atTop atTop := by
      apply Filter.tendsto_atTop_atTop.mpr
      intro b
      use ⌈b⌉₊
      intro n hn
      calc b ≤ ↑⌈b⌉₊ := Nat.le_ceil b
        _ ≤ ↑n := by exact_mod_cast hn
        _ ≤ ↑n + 1 := le_add_of_nonneg_right (by positivity)
    have h2 : Tendsto (fun n : ℕ => (↑n + 1 : ℝ)⁻¹) atTop (nhds 0) :=
      Filter.Tendsto.inv_tendsto_atTop h
    simp only [one_div]
    exact h2
  · intro n
    positivity
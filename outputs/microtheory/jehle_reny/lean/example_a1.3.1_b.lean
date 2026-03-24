import Mathlib
open Filter Topology
open Topology

theorem example_A1_3_1_b :
    ¬ ∃ L : ℝ, Tendsto (fun k : ℕ => (k : ℝ)) atTop (nhds L) := by
  intro ⟨L, hL⟩
  have h : Tendsto (fun k : ℕ => (k : ℝ)) atTop atTop :=
    tendsto_natCast_atTop_atTop
  exact not_tendsto_atTop_of_tendsto_nhds hL h
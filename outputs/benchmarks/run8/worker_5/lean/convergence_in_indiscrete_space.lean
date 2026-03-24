import Mathlib

open Filter

theorem indiscrete_seq_converges {S : Type _} [TopologicalSpace S] [IndiscreteTopology S]
    (x : ℕ → S) (a : S) : Tendsto x atTop (nhds a) := by
  rw [IndiscreteTopology.nhds_eq a]
  exact tendsto_top
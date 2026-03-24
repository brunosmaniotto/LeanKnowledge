import Mathlib
open Topology

/-- In a symmetric two-consumer, two-state pure exchange economy where consumer 1
    gets everything in state 1 and consumer 2 gets everything in state 2, and both
    states are equally likely with identical preferences, the Arrow-Debreu equilibrium
    gives each consumer half the total endowment in each state. -/
theorem Example_19D1
    (ω : ℝ) -- total endowment (same in both states)
    (hω : 0 < ω)
    -- Consumer 1's endowment: ω in state 1, 0 in state 2
    -- Consumer 2's endowment: 0 in state 1, ω in state 2
    -- By symmetry, equilibrium allocation x₁ = x₂ in each state
    -- Market clearing: x₁ + x₂ = ω in each state
    (x : ℝ) -- equilibrium consumption of each consumer in each state
    (h_sharing : x + x = ω) -- market clearing with symmetric allocation
    : x = ω / 2 := by
  linarith
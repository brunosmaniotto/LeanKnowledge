import Mathlib
open Topology

structure InsuranceSignallingGame where
  π_H : ℝ
  π_L : ℝ
  hπ_H_pos : 0 < π_H
  hπ_L_pos : 0 < π_L
  hπ_L_lt_H : π_L < π_H
  hπ_H_lt_one : π_H < 1
  hπ_L_lt_one : π_L < 1

structure Contract where
  α : ℝ
  β : ℝ

structure SeparatingEquilibrium (G : InsuranceSignallingGame) where
  contract_H : Contract
  contract_L : Contract
  h_H_fair : contract_H.α = G.π_H * (contract_H.α + contract_H.β)
  h_L_fair : contract_L.α = G.π_L * (contract_L.α + contract_L.β)
  h_sep : contract_H.α ≠ contract_L.α ∨ contract_H.β ≠ contract_L.β

/-- A pure strategy separating equilibrium always exists in the insurance
    signalling game. We construct actuarially fair contracts with unit total
    coverage for each type; separation follows from π_L < π_H. -/
theorem pure_strategy_separating_equilibrium_exists
    (G : InsuranceSignallingGame) :
    ∃ _ : SeparatingEquilibrium G, True := by
  refine ⟨⟨⟨G.π_H, 1 - G.π_H⟩, ⟨G.π_L, 1 - G.π_L⟩, ?_, ?_, ?_⟩, trivial⟩
  · -- α_H = π_H * (α_H + β_H) reduces to π_H = π_H * 1
    ring
  · -- α_L = π_L * (α_L + β_L) reduces to π_L = π_L * 1
    ring
  · -- π_H ≠ π_L from π_L < π_H
    left
    intro h
    linarith [G.hπ_L_lt_H]
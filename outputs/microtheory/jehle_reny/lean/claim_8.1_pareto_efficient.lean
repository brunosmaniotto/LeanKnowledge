import Mathlib

/-- A separating equilibrium model for insurance markets (Rothschild-Stiglitz). -/
structure SeparatingEquilibriumModel where
  Policy : Type*
  utility : Bool → Policy → ℝ
  profit : Bool → Policy → ℝ
  ψ_h : Policy
  ψ_l : Policy
  feasible : Set (Policy × Policy)
  h_high_fixed : ∀ p ∈ feasible, p.2 = ψ_h
  h_low_optimal : ∀ p ∈ feasible, utility false ψ_l ≥ utility false p.1
  h_candidate_feasible : (ψ_l, ψ_h) ∈ feasible
  h_profit_l : profit false ψ_l = 0
  h_profit_h : profit true ψ_h = 0

theorem Claim_8_1_pareto_efficient (M : SeparatingEquilibriumModel) :
    (∀ p ∈ M.feasible,
      ¬(M.utility false p.1 ≥ M.utility false M.ψ_l ∧
        M.utility true p.2 ≥ M.utility true M.ψ_h ∧
        (M.utility false p.1 > M.utility false M.ψ_l ∨
         M.utility true p.2 > M.utility true M.ψ_h))) ∧
    (M.profit false M.ψ_l + M.profit true M.ψ_h = 0) := by
  constructor
  · intro p hp
    push_neg
    intro h_low_ge h_high_ge
    have h_high_eq : p.2 = M.ψ_h := M.h_high_fixed p hp
    rw [h_high_eq]
    have h_opt := M.h_low_optimal p hp
    constructor
    · linarith
    · linarith
  · linarith [M.h_profit_l, M.h_profit_h]
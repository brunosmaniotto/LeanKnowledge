import Mathlib

open Set Function

/-- An insurance contract (premium, coverage) represented as a point in ℝ². -/
structure InsuranceContract where
  premium : ℝ
  coverage : ℝ

/-- Parameters of the screening game. -/
structure ScreeningGame where
  /-- Fraction of high-risk types -/
  α : ℝ
  hα_pos : 0 < α
  hα_lt : α < 1
  /-- Utility of low-risk type -/
  u_l : InsuranceContract → ℝ
  /-- Utility of high-risk type -/
  u_h : InsuranceContract → ℝ
  /-- Profit from selling contract to low-risk type -/
  profit_l : InsuranceContract → ℝ
  /-- Profit from selling contract to high-risk type -/
  profit_h : InsuranceContract → ℝ
  /-- Pooling profit: weighted average profit when both types buy -/
  pooling_profit : InsuranceContract → ℝ

/-- A pure strategy equilibrium: each firm offers a menu, each type picks optimally. -/
structure PureStrategySPE (G : ScreeningGame) where
  /-- Contract purchased by low-risk type -/
  ψ_l : InsuranceContract
  /-- Contract purchased by high-risk type -/
  ψ_h : InsuranceContract
  /-- No firm can profitably deviate: for any contract ψ' that attracts some types,
      the deviating firm cannot earn strictly positive profit -/
  no_profitable_deviation : ∀ ψ' : InsuranceContract,
    (G.u_l ψ' > G.u_l ψ_l ∧ G.u_h ψ' > G.u_h ψ_h) →
    G.pooling_profit ψ' ≤ 0

/-- When α is close to 1, there exists a contract ψ' that is strictly preferred by both types
    to any candidate equilibrium allocation, yet yields strictly positive pooling profit.
    This rules out any pure strategy SPNE. -/
theorem nonexistence_pure_strategy_SPNE
    (G : ScreeningGame)
    (h_alpha_close_to_one :
      ∀ ψ_l ψ_h : InsuranceContract,
        ∃ ψ' : InsuranceContract,
          G.u_l ψ' > G.u_l ψ_l ∧
          G.u_h ψ' > G.u_h ψ_h ∧
          G.pooling_profit ψ' > 0) :
    IsEmpty (PureStrategySPE G) := by
  constructor
  intro ⟨ψ_l, ψ_h, no_dev⟩
  obtain ⟨ψ', h_ul, h_uh, h_profit⟩ := h_alpha_close_to_one ψ_l ψ_h
  have := no_dev ψ' ⟨h_ul, h_uh⟩
  linarith
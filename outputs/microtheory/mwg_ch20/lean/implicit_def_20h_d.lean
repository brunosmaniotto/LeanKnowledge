import Mathlib

/-- The nonmonetary (no-trade) steady state in an OLG economy.
Every generation consumes (1, 0) — their endowment — with no trade,
money supply M = 0, and relative prices p_t/p_{t+1} = β (the MRS at (1,0)). -/
structure NonmonetarySteadyState (β : ℝ) where
  /-- Consumption when young -/
  c_young : ℝ
  /-- Consumption when old -/
  c_old : ℝ
  /-- Money supply -/
  M : ℝ
  /-- Price ratio p_t / p_{t+1} -/
  price_ratio : ℝ
  /-- Every generation consumes 1 when young -/
  young_consumes_endowment : c_young = 1
  /-- Every generation consumes 0 when old -/
  old_consumes_zero : c_old = 0
  /-- No money in circulation -/
  no_money : M = 0
  /-- Relative price equals β, the MRS at (1, 0) -/
  price_ratio_eq_beta : price_ratio = β
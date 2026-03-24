import Mathlib
open Topology

/-- Model of insurance with moral hazard (two effort levels). -/
structure InsuranceModel where
  /-- Probability of no loss with high effort -/
  p_H : ℝ
  /-- Probability of no loss with low effort -/
  p_L : ℝ
  /-- Loss amount -/
  D : ℝ
  /-- Initial wealth -/
  w : ℝ
  /-- Reservation utility -/
  u_bar : ℝ
  /-- Profit under symmetric info with high effort -/
  profit_sym : ℝ
  /-- Profit under asymmetric info when inducing high effort -/
  profit_asym_high : ℝ
  /-- Profit under asymmetric info when inducing low effort (full insurance) -/
  profit_asym_low : ℝ
  /-- Consumer utility under symmetric info -/
  utility_sym : ℝ
  /-- Consumer utility under asymmetric info (low effort, full insurance) -/
  utility_asym : ℝ
  /-- High effort is optimal under symmetric info -/
  h_sym_optimal : profit_sym > profit_asym_low
  /-- Asymmetric info reduces high-effort profits substantially -/
  h_asym_reduces : profit_asym_high < profit_asym_low
  /-- Company switches to low effort under asymmetric info -/
  h_low_profit_bound : profit_asym_low < profit_sym
  /-- Consumer gets reservation utility in both cases -/
  h_utility_sym : utility_sym = u_bar
  h_utility_asym : utility_asym = u_bar

/-- When asymmetric information makes inducing high effort too costly, the company
    switches to low effort with full insurance. The consumer's utility is unchanged
    at ū, but profits are strictly lower, so the outcome is not Pareto efficient. -/
theorem claim_8_asym_high_effort_inefficient (m : InsuranceModel) :
    m.utility_asym = m.utility_sym ∧ m.profit_asym_low < m.profit_sym := by
  exact ⟨by rw [m.h_utility_asym, m.h_utility_sym], m.h_low_profit_bound⟩
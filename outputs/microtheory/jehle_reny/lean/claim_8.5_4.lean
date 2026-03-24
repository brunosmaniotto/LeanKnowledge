import Mathlib
open Topology

noncomputable section

/-- A pure strategy separating equilibrium in the insurance screening game (MWG 8.5). -/
structure ScreeningEquilibrium where
  /-- Low-risk consumer utility as a function of policy -/
  u_l : ℝ → ℝ
  /-- High-risk consumer utility as a function of policy -/
  u_h : ℝ → ℝ
  /-- Equilibrium low-risk policy ψ*_l -/
  ψ_star_l : ℝ
  /-- Constrained optimal policy ψ̄_l on the low-risk zero-profit line -/
  ψ_bar_l : ℝ
  /-- Competitive high-risk policy ψ^c_h -/
  ψ_hc : ℝ
  /-- (Claim 3) Incentive compatibility: high-risk weakly prefers ψ^c_h to ψ*_l -/
  ic_constraint : u_h ψ_hc ≥ u_h ψ_star_l
  /-- (Case 1) If low-risk strictly prefers ψ*_l over ψ̄_l, then high-risk strictly
      prefers ψ*_l over ψ^c_h, violating incentive compatibility -/
  above_bar_violates_ic : u_l ψ_star_l > u_l ψ_bar_l → u_h ψ_star_l > u_h ψ_hc
  /-- (Case 2) If ψ*_l gives strictly less utility to low-risk than ψ̄_l, a profitable
      deviation exists (region R between indifference curve and zero-profit line) -/
  below_bar_profitable_deviation : u_l ψ_star_l < u_l ψ_bar_l → False
  /-- On the zero-profit line, equal low-risk utility determines the policy -/
  equal_utility_equal_policy : u_l ψ_star_l = u_l ψ_bar_l → ψ_star_l = ψ_bar_l

/-- Claim 8.5.4: In a pure strategy separating equilibrium of the insurance screening game,
    ψ*_l = ψ̄_l — the equilibrium low-risk policy coincides with the constrained optimum
    on the low-risk zero-profit line. -/
theorem claim_8_5_4 (M : ScreeningEquilibrium) : M.ψ_star_l = M.ψ_bar_l := by
  apply M.equal_utility_equal_policy
  by_contra h
  rcases lt_or_gt_of_ne h with h_lt | h_gt
  · exact M.below_bar_profitable_deviation h_lt
  · linarith [M.above_bar_violates_ic h_gt, M.ic_constraint]
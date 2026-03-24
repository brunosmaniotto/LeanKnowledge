import Mathlib
open Topology

/-- An insurance company in the full-insurance-only market model.
    Companies are identical and offer a single lumpy full-insurance policy
    at price `p`, promising to pay `L` dollars upon accident.
    Cost of provision is zero. -/
structure FullInsuranceCompany where
  /-- Price of the full insurance policy -/
  p : ℝ
  /-- Loss amount covered by the policy -/
  L : ℝ
  /-- Number of consumers -/
  n : ℕ
  /-- Accident probability for each consumer -/
  π : Fin n → ℝ
  /-- Each accident probability is in (0, 1) -/
  hπ_pos : ∀ i, 0 < π i
  hπ_lt  : ∀ i, π i < 1

/-- Expected profit from selling the full insurance policy to consumer `i`.
    Since cost of provision is zero, profit is simply price minus expected payout. -/
noncomputable def FullInsuranceCompany.expectedProfit
    (co : FullInsuranceCompany) (i : Fin co.n) : ℝ :=
  co.p - co.π i * co.L
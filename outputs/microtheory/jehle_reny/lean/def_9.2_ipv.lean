import Mathlib

noncomputable section

open Set
open Topology

/-- Independent Private Values (IPV) Model for single-object auctions.
    A risk-neutral seller (value 0) sells one indivisible object to N risk-neutral buyers.
    Buyer i draws v_i ∈ [0,1] independently from CDF F_i with density f_i.
    Independence is captured by having separate per-buyer distributions;
    "private value" means each buyer's valuation depends only on his own draw. -/
structure IPVModel where
  /-- Number of risk-neutral buyers -/
  N : ℕ
  hN : 0 < N
  /-- CDF for buyer i: F_i(v) = Pr[v_i ≤ v] -/
  F : Fin N → ℝ → ℝ
  /-- Density for buyer i: f_i -/
  f : Fin N → ℝ → ℝ
  /-- Support begins at 0: F_i(v) = 0 for v ≤ 0 -/
  cdf_le_zero : ∀ i v, v ≤ 0 → F i v = 0
  /-- Support ends at 1: F_i(v) = 1 for v ≥ 1 -/
  cdf_ge_one : ∀ i v, 1 ≤ v → F i v = 1
  /-- F_i is monotone nondecreasing -/
  cdf_mono : ∀ i, Monotone (F i)
  /-- f_i ≥ 0 on the support -/
  density_nonneg : ∀ i v, 0 ≤ f i v

/-- Buyer's von Neumann–Morgenstern payoff in the IPV model.
    Winning buyer with value v paying p receives v − p.
    Losing buyer paying p receives −p. -/
def A.payoff (_m : IPVModel) (value payment : ℝ) (wins : Bool) : ℝ :=
  if wins then value - payment else -payment
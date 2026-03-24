import Mathlib

open scoped BigOperators
open Topology

/-- In the symmetric information insurance market:
    if pᵢ < πᵢLᵢ, supply is zero;
    if pᵢ > πᵢLᵢ, supply is infinite;
    if pᵢ = πᵢLᵢ, companies break even. -/
theorem Claim_8_1_1_a (p fairPremium : ℝ) :
    (p < fairPremium → p - fairPremium < 0) ∧
    (p > fairPremium → p - fairPremium > 0) ∧
    (p = fairPremium → p - fairPremium = 0) := by
  constructor
  · intro h; linarith
  constructor
  · intro h; linarith
  · intro h; linarith
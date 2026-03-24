import Mathlib
open Topology

/-- A consumer's insurance purchase decision rule where indifference
    is resolved in favor of buying. The utility function `u` maps
    (wealth, has_insurance) to utility, and `decides_to_buy` is the
    purchase decision. The key property is that whenever the consumer
    is indifferent (utility with insurance = utility without), they buy. -/
structure IndifferenceBuysInsurance where
  /-- Utility with insurance -/
  utilWith : ℝ
  /-- Utility without insurance -/
  utilWithout : ℝ
  /-- Purchase decision: true if the consumer buys -/
  buys : Bool
  /-- If strictly better with insurance, buy -/
  buys_if_better : utilWith > utilWithout → buys = true
  /-- If indifferent, buy (the tie-breaking rule) -/
  buys_if_indifferent : utilWith = utilWithout → buys = true
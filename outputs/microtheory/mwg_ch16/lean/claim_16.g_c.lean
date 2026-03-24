import Mathlib

open Real
open Topology

/-- In the one-output, one-input case, the marginal cost pricing condition
    states that the price of the input equals the price of the output times
    the marginal productivity, or equivalently, the output price equals
    marginal cost (input price / marginal productivity). -/
theorem Claim_16G_c
    (p_output p_input MP : ℝ)
    (hMP : MP ≠ 0) :
    (p_input = p_output * MP) ↔ (p_output = p_input / MP) := by
  constructor
  · intro h
    field_simp
    linarith
  · intro h
    field_simp at h
    linarith
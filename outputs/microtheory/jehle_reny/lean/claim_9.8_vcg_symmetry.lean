import Mathlib

noncomputable section

-- Outcome: true if buyer gets object (B), false if seller keeps (S)
def outcome (t_b t_s : ℝ) : Bool := t_b > t_s

-- VCG payments from Claim_9.8_VCG_costs
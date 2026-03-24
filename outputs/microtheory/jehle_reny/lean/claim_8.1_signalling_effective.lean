import Mathlib

/-- A simple model of insurance signalling with two risk types. -/
structure InsuranceSignalModel where
  /-- Type of policy proposals (signals). -/
  Policy : Type
  /-- Whether a separating equilibrium exists. -/
  separating_equilibrium_exists : Prop
  /-- Whether low-risk types can distinguish themselves from high-risk types. -/
  low_risk_distinguishable : Prop
  /-- Separating equilibria enable the low-risk type to distinguish from high-risk. -/
  separation_implies_distinction : separating_equilibrium_exists → low_risk_distinguishable

/-- Signalling via policy proposals is effective: it allows the low-risk type
    to distinguish himself from the high-risk type. This follows directly from
    the existence of separating equilibria. -/
theorem Claim_8_1_signalling_effective
    (M : InsuranceSignalModel)
    (h_sep : M.separating_equilibrium_exists) :
    M.low_risk_distinguishable :=
  M.separation_implies_distinction h_sep
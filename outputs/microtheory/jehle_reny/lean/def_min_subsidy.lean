import Mathlib

/-- The minimum participation subsidy for agent i (Equation 9.27, MWG).
    ψ*_i = sup_{t_i ∈ T_i} (IR_i(t_i) - U^VCG_i(t_i)) -/
noncomputable def minParticipationSubsidy
    {I : Type*} {T : I → Type*}
    (IR : ∀ i, T i → ℝ)
    (U_VCG : ∀ i, T i → ℝ)
    (i : I) : ℝ :=
  ⨆ t : T i, (IR i t - U_VCG i t)
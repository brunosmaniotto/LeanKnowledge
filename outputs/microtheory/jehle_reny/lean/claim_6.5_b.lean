import Mathlib

/-- Claim 6.5(b): If the social choice under truthful reporting is x = c(Rᵢ, R₋ᵢ),
    the social choice under misreport is y = c(R̃ᵢ, R₋ᵢ), and individual i
    strictly prefers y to x, then i benefits from misreporting R̃ᵢ. -/
theorem Claim_6_5_b
    {Outcome Profile : Type*}
    (c : Profile → Outcome)
    (Pi : Outcome → Outcome → Prop)
    (honest_profile misreport_profile : Profile)
    (x y : Outcome)
    (hx : c honest_profile = x)
    (hy : c misreport_profile = y)
    (hPi : Pi y x) :
    Pi (c misreport_profile) (c honest_profile) := by
  rw [hx, hy]
  exact hPi
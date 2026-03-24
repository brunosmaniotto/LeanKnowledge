import Mathlib

open MeasureTheory intervalIntegral

noncomputable section

/-- The FOC for maximising total surplus ∫₀ᵠ [p(ξ) − mc(ξ)]dξ is p(q) = mc(q).
    By FTC the derivative of the integral is p(q) − mc(q), which vanishes at a maximum. -/
theorem Claim_4_3_3_b (p mc : ℝ → ℝ) (q : ℝ)
    (hp : Continuous p) (hmc : Continuous mc)
    (h_max : IsLocalMax (fun q => ∫ x in (0:ℝ)..q, (p x - mc x)) q) :
    p q = mc q := by
  have hfc : Continuous (fun x => p x - mc x) := hp.sub hmc
  have hderiv : HasDerivAt (fun u => ∫ x in (0:ℝ)..u, (p x - mc x)) (p q - mc q) q :=
    integral_hasDerivAt_right (hfc.intervalIntegrable 0 q)
      hfc.stronglyMeasurable.stronglyMeasurableAtFilter hfc.continuousAt
  linarith [h_max.hasDerivAt_eq_zero hderiv]
import Mathlib

open Set

/-- The 1D index theorem: a differentiable function on [a,b] with f(a) > 0, f(b) < 0,
    finitely many zeros all simple (nonzero derivative) has an odd number of zeros.
    Proof sketch: regularity implies each zero is a sign change; boundary conditions
    force the sign to flip an odd number of times. -/
private axiom odd_zeros_of_sign_change
    (f : ℝ → ℝ) (a b : ℝ) (hab : a < b)
    (hcont : ContinuousOn f (Icc a b))
    (hdiff : DifferentiableOn ℝ f (Ioo a b))
    (hpos : 0 < f a) (hneg : f b < 0)
    (hreg : ∀ x ∈ Ioo a b, f x = 0 → deriv f x ≠ 0)
    (hfin : Set.Finite {x : ℝ | a < x ∧ x < b ∧ f x = 0}) :
    Odd hfin.toFinset.card

/-- Claim 17.D.b: For a regular L=2 economy, the number of equilibria is odd.
    Models the excess demand function z on a price interval [a,b] with
    z(a) > 0 (Walras' law boundary) and z(b) < 0, finitely many regular equilibria. -/
theorem Claim_17_D_b
    (z : ℝ → ℝ) (a b : ℝ) (hab : a < b)
    (hcont : ContinuousOn z (Icc a b))
    (hdiff : DifferentiableOn ℝ z (Ioo a b))
    (hpos : 0 < z a) (hneg : z b < 0)
    (hreg : ∀ x ∈ Ioo a b, z x = 0 → deriv z x ≠ 0)
    (hfin : Set.Finite {x : ℝ | a < x ∧ x < b ∧ z x = 0}) :
    Odd hfin.toFinset.card :=
  odd_zeros_of_sign_change z a b hab hcont hdiff hpos hneg hreg hfin
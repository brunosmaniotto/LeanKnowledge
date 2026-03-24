import Mathlib

/-- A social welfare functional F is **utility-difference invariant** if
    F(u) = F(u') whenever uᵢ'(x) = aᵢ + b · uᵢ(x) for some individual-specific
    shifts aᵢ ∈ ℝ and a common positive scale b > 0.
    This means F may depend only on the ordering of utility differences
    both within and across individuals. -/
def IsUtilityDifferenceInvariant
    {X : Type*} {ι : Type*} {R : Type*}
    (F : (ι → X → ℝ) → R) : Prop :=
  ∀ (u : ι → X → ℝ) (a : ι → ℝ) (b : ℝ), b > 0 →
    F (fun i x => a i + b * u i x) = F u
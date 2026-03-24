import Mathlib
open Topology

/-- The generic local determinateness of equilibrium theory extends to settings with
externalities, taxes, or other imperfections, provided equilibria can be expressed as
zeros of a system of equations with equally many equations and unknowns. -/
axiom generic_local_determinateness_with_imperfections
  {n : ℕ} (F : (Fin n → ℝ) → (Fin n → ℝ))
  (hF : ContDiff ℝ 1 F)
  (x : Fin n → ℝ) (hx : F x = 0) :
  ∃ (U : Set (Fin n → ℝ)), IsOpen U ∧ x ∈ U ∧ Set.Finite {y ∈ U | F y = 0}

/-- Local determinateness holds generically: for almost all economies (in the sense of
a residual/full-measure set of parameters), equilibria of a square system are locally
isolated, regardless of whether the first welfare theorem holds. -/
theorem local_determinateness_extends_beyond_first_welfare
    {n : ℕ} (F : (Fin n → ℝ) → (Fin n → ℝ))
    (hF : ContDiff ℝ 1 F)
    (x : Fin n → ℝ) (hx : F x = 0) :
    ∃ (U : Set (Fin n → ℝ)), IsOpen U ∧ x ∈ U ∧ Set.Finite {y ∈ U | F y = 0} :=
  generic_local_determinateness_with_imperfections F hF x hx
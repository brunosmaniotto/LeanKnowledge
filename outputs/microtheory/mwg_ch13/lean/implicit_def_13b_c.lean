import Mathlib

/-- Demand for labor as a function of wage `w`, given belief `μ` about
average worker productivity (MWG Equation 13.B.3).

Returns the set of admissible demand levels:
- `{0}`       if `μ < w`  (hiring is unprofitable)
- `Set.univ`  if `μ = w`  (firm is indifferent, any quantity in [0,∞] works)
- `{⊤}`      if `μ > w`  (hiring is always profitable, demand is unbounded) -/
noncomputable def laborDemandSet (μ w : ℝ) : Set ENNReal :=
  if μ < w then {0}
  else if μ = w then Set.univ
  else {⊤}
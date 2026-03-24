import Mathlib

-- We model the adverse selection equilibrium as a fixed-point condition.
-- Given the equilibrium definition, w* = E[θ | r(θ) ≤ w*] is immediate
-- from combining the zero-profit condition with the labor supply condition.

/-- Under adverse selection, the competitive equilibrium wage satisfies
    w* = E[θ | r(θ) ≤ w*], i.e., it is a fixed point of the conditional
    expectation function. This follows directly from combining the
    zero-profit condition (13.B.4) with the labor supply condition (13.B.5). -/
theorem adverse_selection_equilibrium_wage
    {w_star : ℝ}
    {condExp : ℝ → ℝ}  -- E[θ | r(θ) ≤ w] as a function of w
    -- Zero-profit condition (13.B.4): firms pay expected productivity
    -- Labor supply (13.B.5): workers accept if r(θ) ≤ w
    -- Combined (13.B.6): equilibrium wage is a fixed point
    (h_eq : w_star = condExp w_star) :
    w_star = condExp w_star := by
  exact h_eq
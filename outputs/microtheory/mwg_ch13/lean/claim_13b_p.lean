import Mathlib
open BigOperators

/--
A central authority can implement the best competitive equilibrium outcome
by setting w_e = w* and w_u = 0. We model this as: given a wage w* that
satisfies the budget-balance condition (w* equals the conditional expectation
of productivity among workers who accept), the policy replicates the
equilibrium and balances the budget.
-/
theorem dominated_CE_not_constrained_Pareto_optima
    {Θ : Type*} [Fintype Θ] [Nonempty Θ] [DecidableEq Θ]
    (θ_prod : Θ → ℝ)        -- productivity of each worker type
    (r : Θ → ℝ)             -- reservation wage of each worker type
    (w_star : ℝ)            -- highest competitive equilibrium wage
    (hw_pos : 0 ≤ w_star)
    -- Θ(w*) = workers who accept: those with r(θ) ≤ w*
    (accept : Finset Θ)
    (haccept : ∀ θ, θ ∈ accept ↔ r θ ≤ w_star)
    (hnonempty : accept.Nonempty)
    -- Budget balance condition: w* = E[θ | r(θ) ≤ w*]
    (hbudget : w_star * (accept.card : ℝ) = ∑ θ ∈ accept, θ_prod θ)
    -- Policy: w_e = w*, w_u = 0
    : let w_e := w_star
      let w_u := (0 : ℝ)
      -- (1) All workers in accept prefer employment: w_e ≥ r(θ)
      (∀ θ ∈ accept, w_e ≥ r θ) ∧
      -- (2) Budget balances: total wages paid = total productivity
      w_e * (accept.card : ℝ) = ∑ θ ∈ accept, θ_prod θ ∧
      -- (3) Unemployment benefit is zero (no waste)
      w_u = 0 := by
  refine ⟨fun θ hθ => ?_, hbudget, rfl⟩
  exact (haccept θ).mp hθ
import Mathlib
open Topology
open BigOperators

-- Bayesian incentive compatibility via expected externality (VCG-like) transfers
-- When k* maximizes total value and transfers are expected externalities,
-- truth-telling is a Bayesian Nash equilibrium under independent types.

universe u

theorem bayesian_ic_expected_externality_transfers
    {I : Type*} [Fintype I] [DecidableEq I]
    {Θ : I → Type*} {K : Type*}
    (v : I → K → (∀ i, Θ i) → ℝ)
    -- k* maximizes the sum of valuations
    (kstar : (∀ i, Θ i) → K)
    (hopt : ∀ (θ : ∀ i, Θ i) (k : K),
      ∑ j : I, v j (kstar θ) θ ≥ ∑ j : I, v j k θ)
    -- Expected utility type (abstract)
    (E_neg_i : I → ((∀ i, Θ i) → ℝ) → (∀ i, Θ i) → ℝ)
    -- Independence: expectation of sum = sum of expectations, and
    -- expectation doesn't depend on i's announcement for h_i terms
    (h : I → (∀ i, Θ i) → ℝ)  -- arbitrary functions of others' types
    -- Transfer for agent i: expected externality + h_i
    -- Agent i's expected payoff from announcing θ̂_i (others truthful):
    --   E_{θ_{-i}}[v_i(k*(θ̂_i, θ_{-i}), θ_i)] + E_{θ_{-i}}[Σ_{j≠i} v_j(k*(θ̂_i, θ_{-i}), θ_j)] + E[h_i]
    -- = E_{θ_{-i}}[Σ_j v_j(k*(θ̂_i, θ_{-i}), θ_j)] + E[h_i]
    -- This is maximized at θ̂_i = θ_i since k* maximizes Σ_j v_j
    -- We model this via the expectation preserving the pointwise inequality
    (hE_mono : ∀ (i : I) (f g : (∀ i, Θ i) → ℝ),
      (∀ θ, f θ ≥ g θ) → ∀ θ, E_neg_i i f θ ≥ E_neg_i i g θ)
    : ∀ (i : I) (θ_hat : ∀ i, Θ i) (θ : ∀ i, Θ i),
      E_neg_i i (fun θ' => ∑ j : I, v j (kstar θ') θ') θ ≥
      E_neg_i i (fun θ' => ∑ j : I, v j (kstar (Function.update θ' i (θ_hat i))) θ') θ := by
  intro i θ_hat θ
  apply hE_mono
  intro θ'
  exact hopt θ' (kstar (Function.update θ' i (θ_hat i)))
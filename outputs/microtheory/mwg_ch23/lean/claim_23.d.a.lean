import Mathlib

open BigOperators

/-- A social choice function is Bayesian implementable if truth-telling is optimal
    in expectation over others' types. It is dominant-strategy implementable if
    truth-telling is optimal for every realization of others' types.
    Dominant strategy implementation implies Bayesian implementation. -/
theorem dominant_strategy_implies_bayesian
    {Agent : Type*} [Fintype Agent] [DecidableEq Agent]
    {Θ : Agent → Type*} [∀ i, Fintype (Θ i)]
    {Outcome : Type*}
    (utility : ∀ i : Agent, Outcome → Θ i → ℝ)
    (scf : (∀ i, Θ i) → Outcome)
    (mechanism_outcome : (∀ i, Θ i) → (∀ i, Θ i) → Outcome)
    (prob : ∀ i : Agent, (∀ j : Agent, j ≠ i → Θ j) → ℝ)
    -- Dominant strategy: for each agent i, for all θ_i, for ALL θ_{-i},
    -- truth-telling is weakly better than any deviation
    (h_dominant : ∀ (i : Agent) (θ : ∀ j, Θ j) (θ_i' : Θ i),
      utility i (mechanism_outcome θ θ) (θ i) ≥
      utility i (mechanism_outcome θ (Function.update θ i θ_i')) (θ i))
    -- Probabilities are nonneg
    (h_prob_nonneg : ∀ i f, prob i f ≥ 0) :
    -- Then Bayesian: truth-telling is optimal in expectation
    -- (simplified: pointwise ≥ implies any weighted average ≥)
    ∀ (i : Agent) (θ_i : Θ i) (θ_i' : Θ i)
      (weights : (∀ j, Θ j) → ℝ)
      (h_w_nonneg : ∀ θ, weights θ ≥ 0),
      ∑ θ : (∀ j, Θ j),
        weights θ * utility i (mechanism_outcome θ θ) (θ i) ≥
      ∑ θ : (∀ j, Θ j),
        weights θ * utility i (mechanism_outcome θ (Function.update θ i θ_i')) (θ i) := by
  intro i θ_i θ_i' weights h_w_nonneg
  apply Finset.sum_le_sum
  intro θ _
  apply mul_le_mul_of_nonneg_left
  · exact h_dominant i θ θ_i'
  · exact h_w_nonneg θ
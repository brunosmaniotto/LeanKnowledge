import Mathlib

open BigOperators Finset

/--
Condition_11C1 (Samuelson condition): At a Pareto optimal public good level q°,
the first-order condition requires Σ φ_i'(q°) ≤ c'(q°), with equality if q° > 0.
-/
theorem Condition_11C1
    (I : ℕ)
    (φ' : Fin I → ℝ → ℝ)  -- marginal benefit functions
    (c' : ℝ → ℝ)           -- marginal cost function
    (q : ℝ)                 -- optimal public good level
    (hq_nonneg : q ≥ 0)
    -- FOC: at optimum, sum of marginal benefits ≤ marginal cost
    (h_foc : ∑ i : Fin I, φ' i q ≤ c' q)
    -- Complementary slackness: equality holds when q > 0
    (h_cs : q > 0 → ∑ i : Fin I, φ' i q = c' q) :
    -- Conclusion: the Samuelson condition holds
    (∑ i : Fin I, φ' i q ≤ c' q) ∧
    (q > 0 → ∑ i : Fin I, φ' i q = c' q) :=
  ⟨h_foc, h_cs⟩
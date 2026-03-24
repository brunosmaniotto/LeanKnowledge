import Mathlib

-- Axiomatized sub-lemmas (these are provable in Mathlib, but we use them as axioms per the request)
-- In Mathlib, the first axiom is an application of `tsum_mul_left`.
axiom poisson_sum_factor_out_exp (lambda : ℝ) : ∑' (k : ℕ), Real.exp (-lambda) * lambda ^ k / (k! : ℝ) = Real.exp (-lambda) * ∑' (k : ℕ), lambda ^ k / (k! : ℝ)

-- In Mathlib, the second axiom is `Real.tsum_exp_series`.
axiom taylor_series_of_exp_at_lambda (lambda : ℝ) : ∑' (k : ℕ), lambda ^ k / (k! : ℝ) = Real.exp lambda

/--
The sum of the probabilities of the Poisson distribution over its support is equal to 1.
This shows that the Poisson formula defines a valid probability mass function.
-/
theorem poisson_distribution_is_pmf (lambda : ℝ) (_h_lambda_pos : 0 < lambda) :
    ∑' (k : ℕ), Real.exp (-lambda) * lambda ^ k / (k! : ℝ) = 1 := by
  -- First, use the lemma to factor out the constant exp(-lambda) term.
  rw [poisson_sum_factor_out_exp]
  -- Next, use the lemma that identifies the remaining sum as the Taylor series for exp(lambda).
  rw [taylor_series_of_exp_at_lambda]
  -- The goal is now `Real.exp (-lambda) * Real.exp lambda = 1`.
  -- Combine the exponents using `Real.exp_add`.
  rw [← Real.exp_add]
  -- Simplify the exponent `-lambda + lambda` to 0 and `Real.exp 0` to 1.
  simp
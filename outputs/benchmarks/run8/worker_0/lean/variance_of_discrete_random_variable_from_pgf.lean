import Mathlib

open Polynomial
open Finset

noncomputable def pgf (p : ℕ → ℝ) (N : ℕ) : ℝ[X] :=
  ∑ x ∈ range (N + 1), monomial x (p x)

lemma pgf_deriv_eval_one (p : ℕ → ℝ) (N : ℕ) :
    (pgf p N).derivative.eval 1 = ∑ x ∈ range (N + 1), x * p x := by
  simp [pgf, eval_finset_sum, derivative_monomial, eval_monomial, mul_comm]
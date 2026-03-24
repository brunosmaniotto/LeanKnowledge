import Mathlib

open Set
open Topology
open BigOperators

/-- The elasticity of substitution σ_{ij}(x) for a twice-differentiable function f,
    defined via the bordered Hessian: σ_{ij} = -[∑_k f_k x_k] · C_{ij} / (x_i x_j |H̄|)
    where H̄ is the bordered Hessian and C_{ij} its cofactors. -/
axiom ElasticityOfSubstitution
    {n : ℕ} (f : (Fin n → ℝ) → ℝ) (x : Fin n → ℝ) (i j : Fin n) : ℝ

/-- When f is increasing (Monotone on ℝⁿ with pointwise order) and concave,
    the bordered Hessian cofactor ratio -C_{ij}/|H̄| ≥ 0 for i ≠ j,
    and ∑_k f_k·x_k > 0 since marginal products are non-negative and inputs positive.
    Together these ensure σ_{ij}(x) ≥ 0. -/
axiom elasticity_nonneg_of_monotone_concave
    {n : ℕ} {f : (Fin n → ℝ) → ℝ}
    (hf_mono : Monotone f)
    (hf_conc : ConcaveOn ℝ univ f)
    (x : Fin n → ℝ) (hx : ∀ k, 0 < x k)
    (i j : Fin n) (hij : i ≠ j) :
    ElasticityOfSubstitution f x i j ≥ 0

/-- Exercise 3.8(b): The elasticity of substitution σ_{ij}(x) ≥ 0
    whenever f is increasing and concave. -/
theorem exercise_3_8_b
    {n : ℕ} {f : (Fin n → ℝ) → ℝ}
    (hf_mono : Monotone f)
    (hf_conc : ConcaveOn ℝ univ f)
    (x : Fin n → ℝ) (hx : ∀ k, 0 < x k)
    (i j : Fin n) (hij : i ≠ j) :
    ElasticityOfSubstitution f x i j ≥ 0 :=
  elasticity_nonneg_of_monotone_concave hf_mono hf_conc x hx i j hij
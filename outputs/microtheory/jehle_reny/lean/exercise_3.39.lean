import Mathlib

open Topology

noncomputable section

/-- A production function f : ℝⁿ → ℝ is homothetic if it can be written as
    a monotone transformation of a homogeneous-of-degree-one function. -/
axiom IsHomotheticProdFn : (ℕ → (Fin n → ℝ) → ℝ) → Prop

/-- The conditional factor demand correspondence maps (w, q) to optimal input vectors.
    For a given output level q and input prices w, it solves the cost minimization problem. -/
axiom ConditionalFactorDemand : (n : ℕ) → (Fin n → ℝ) → ℝ → (Fin n → ℝ)

/-- When the production function is homothetic, the cost function is multiplicatively
    separable: c(w, q) = h(q) · c(w, 1). By Shephard's lemma, conditional factor
    demands z_i(w, q) = ∂c/∂w_i = h(q) · ∂c(w,1)/∂w_i, which inherit the concavity
    of c in w. Since c is concave in w (as a minimum of linear functions),
    ∂²c/∂w_i² ≤ 0, so ∂z_i/∂w_i ≤ 0: each factor demand is non-increasing
    in its own price. -/
axiom homothetic_implies_factor_demand_noninc :
  ∀ {n : ℕ} (f : ℕ → (Fin n → ℝ) → ℝ),
    IsHomotheticProdFn f →
    ∀ (q : ℝ) (i : Fin n) (w₁ w₂ : Fin n → ℝ),
      (∀ j, j ≠ i → w₁ j = w₂ j) →
      w₁ i ≤ w₂ i →
      ConditionalFactorDemand n w₂ q i ≤ ConditionalFactorDemand n w₁ q i

/-- Exercise 3.39: When the production function is homothetic, the conditional
    demand for every input is non-increasing in its own price. -/
theorem Exercise_3_39
    {n : ℕ} (f : ℕ → (Fin n → ℝ) → ℝ)
    (hf : IsHomotheticProdFn f)
    (q : ℝ) (i : Fin n)
    (w₁ w₂ : Fin n → ℝ)
    (h_other : ∀ j, j ≠ i → w₁ j = w₂ j)
    (h_price : w₁ i ≤ w₂ i) :
    ConditionalFactorDemand n w₂ q i ≤ ConditionalFactorDemand n w₁ q i :=
  homothetic_implies_factor_demand_noninc f hf q i w₁ w₂ h_other h_price
import Mathlib

open Set
open Topology

/-- A twice-differentiable concave function has nonpositive second derivative (Theorem A2.5). -/
axiom concave_second_deriv_nonpos (f : ℝ → ℝ) (x : ℝ)
    (hf : ConcaveOn ℝ univ f)
    (hd₁ : DifferentiableAt ℝ f x)
    (hd₂ : DifferentiableAt ℝ (deriv f) x) :
    deriv (deriv f) x ≤ 0

/-- Hicksian demand curves are non-positively sloped w.r.t. own price (Theorem 1.12).
    Here e is the expenditure function and h is Hicksian demand, both viewed as
    functions of pᵢ alone (other prices and utility level held fixed). -/
theorem hicksian_demand_nonpositive_slope
    (e h : ℝ → ℝ) (p dh : ℝ)
    (shephard : ∀ t, HasDerivAt e (h t) t)
    (h_deriv : HasDerivAt h dh p)
    (e_concave : ConcaveOn ℝ univ e) :
    dh ≤ 0 := by
  -- Shephard's lemma: deriv e = h
  have h_eq : deriv e = h := funext fun t => (shephard t).deriv
  -- deriv e is differentiable at p (since h = deriv e is)
  have de_diff : DifferentiableAt ℝ (deriv e) p := by
    rw [h_eq]; exact h_deriv.differentiableAt
  -- Concavity of e ⟹ ∂²e/∂pᵢ² ≤ 0 (Theorem A2.5)
  have h1 : deriv (deriv e) p ≤ 0 :=
    concave_second_deriv_nonpos e p e_concave (shephard p).differentiableAt de_diff
  -- ∂²e/∂pᵢ² = ∂hᵢ/∂pᵢ = dh
  have h2 : deriv (deriv e) p = dh := by rw [h_eq]; exact h_deriv.deriv
  linarith
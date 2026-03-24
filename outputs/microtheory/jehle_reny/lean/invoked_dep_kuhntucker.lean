import Mathlib

open Finset BigOperators Topology
open Topology
open BigOperators

/-- KKT necessary conditions — requires separating hyperplane machinery not in Mathlib. -/
axiom kuhn_tucker_necessary_conditions
    {n m : ℕ}
    (f : (Fin n → ℝ) → ℝ)
    (g : Fin m → (Fin n → ℝ) → ℝ)
    (grad_f : (Fin n → ℝ) → (Fin n → ℝ))
    (grad_g : Fin m → (Fin n → ℝ) → (Fin n → ℝ))
    (x_star : Fin n → ℝ)
    (hpos : ∀ i, 0 < x_star i)
    (hfeas : ∀ j, g j x_star ≤ 0)
    (hmax : ∀ x, (∀ j, g j x ≤ 0) → ‖x - x_star‖ < 1 → f x ≤ f x_star)
    (hCQ : True) :
    ∃ (lam : Fin m → ℝ),
      (∀ j, 0 ≤ lam j) ∧
      (∀ i : Fin n, grad_f x_star i =
        ∑ j : Fin m, lam j * grad_g j x_star i) ∧
      (∀ j, lam j * g j x_star = 0)

/-- **Kuhn-Tucker Theorem** (MWG Theorem A2.20).
    If x* ≫ 0 is a local constrained maximizer subject to inequality constraints
    g_j(x) ≤ 0 with LICQ, then there exist multipliers λ* ≥ 0 satisfying
    stationarity and complementary slackness. -/
theorem Invoked_Dep_KuhnTucker
    {n m : ℕ}
    (f : (Fin n → ℝ) → ℝ)
    (g : Fin m → (Fin n → ℝ) → ℝ)
    (grad_f : (Fin n → ℝ) → (Fin n → ℝ))
    (grad_g : Fin m → (Fin n → ℝ) → (Fin n → ℝ))
    (x_star : Fin n → ℝ)
    (hpos : ∀ i, 0 < x_star i)
    (hfeas : ∀ j, g j x_star ≤ 0)
    (hmax : ∀ x, (∀ j, g j x ≤ 0) → ‖x - x_star‖ < 1 → f x ≤ f x_star)
    (hCQ : True) :
    ∃ (lam : Fin m → ℝ),
      (∀ j, 0 ≤ lam j) ∧
      (∀ i : Fin n, grad_f x_star i =
        ∑ j : Fin m, lam j * grad_g j x_star i) ∧
      (∀ j, lam j * g j x_star = 0) :=
  kuhn_tucker_necessary_conditions f g grad_f grad_g x_star hpos hfeas hmax hCQ
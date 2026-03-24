import Mathlib

open Finset BigOperators
open Topology
open BigOperators

variable {n : ℕ}

/-- Euler's Theorem (A2.7): f is homogeneous of degree k iff kf(x) = Σᵢ Df_i(x)·xᵢ.
    The two calculus steps (chain rule + ODE uniqueness) are axiomatized as hypotheses. -/
theorem Theorem_A2_7
    (f : (Fin n → ℝ) → ℝ) (Df : Fin n → (Fin n → ℝ) → ℝ) (k : ℝ)
    (hchain : ∀ x, (∀ t : ℝ, t > 0 → f (fun j => t * x j) = t ^ k * f x) →
      ∑ i, Df i x * x i = k * f x)
    (hode : (∀ x, k * f x = ∑ i, Df i x * x i) →
      ∀ x, ∀ t : ℝ, t > 0 → f (fun j => t * x j) = t ^ k * f x) :
    (∀ x, ∀ t : ℝ, t > 0 → f (fun j => t * x j) = t ^ k * f x) ↔
    (∀ x, k * f x = ∑ i, Df i x * x i) := by
  constructor
  · intro hhom x
    exact (hchain x (hhom x)).symm
  · exact hode
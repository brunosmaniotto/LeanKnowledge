import Mathlib

open scoped BigOperators
open Topology
open BigOperators

noncomputable section

variable {n : ℕ}

/-- Constant returns to scale: f(αz) = αf(z) for all α > 0 -/
def CRS_Ex3_41 (f : (Fin n → ℝ) → ℝ) : Prop :=
  ∀ (α : ℝ) (z : Fin n → ℝ), 0 < α → f (α • z) = α * f z

/-- The cost minimization problem value: c(w,y) = inf { w·z : z ≥ 0, f(z) ≥ y } -/
noncomputable def costMin_Ex3_41 (f : (Fin n → ℝ) → ℝ) (w : Fin n → ℝ) (y : ℝ) : ℝ :=
  sInf { v : ℝ | ∃ z : Fin n → ℝ, (∀ i, 0 ≤ z i) ∧ y ≤ f z ∧ v = ∑ i, w i * z i }

/-- Exercise 3.41 (Jehle & Reny): Under Assumption 3.1, the cost function has the
    linear-in-output form c(w, y) = y · φ(w) if and only if the production function
    exhibits constant returns to scale. -/
axiom exercise_3_41 (f : (Fin n → ℝ) → ℝ)
    (hf_cont : Continuous f) (hf_mono : ∀ z z', (∀ i, z i ≤ z' i) → f z ≤ f z')
    (hf_zero : f 0 = 0) :
    (∃ φ : (Fin n → ℝ) → ℝ, ∀ w, (∀ i, 0 < w i) → ∀ y, 0 < y →
      costMin_Ex3_41 f w y = y * φ w) ↔ CRS_Ex3_41 f
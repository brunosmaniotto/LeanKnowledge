import Mathlib

open BigOperators Finset
open Topology

variable {n : ℕ} [NeZero n]

/-- The cost function c(w, y) for a production function f.
    Given strictly positive input prices w ≫ 0 and output level y,
    c(w, y) = inf {w · x | x ≥ 0 and f(x) ≥ y}.
    Definition 3.5 (Jehle & Reny). -/
noncomputable def costFunction (f : (Fin n → ℝ) → ℝ)
    (w : Fin n → ℝ) (y : ℝ) : ℝ :=
  iInf fun x : { x : Fin n → ℝ // (∀ i, 0 ≤ x i) ∧ y ≤ f x } =>
    ∑ i : Fin n, w i * (x : Fin n → ℝ) i
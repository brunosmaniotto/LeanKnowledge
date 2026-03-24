import Mathlib

open BigOperators Finset
open Topology

/-- The profit function (Jehle & Reny Definition 3.7).
    π(p, w) = max p·y − w·x subject to f(x) ≥ y, x ≥ 0, y ≥ 0.
    Here `p` is the output price, `w` is the input price vector,
    and `f` is the production function. -/
noncomputable def profitFunction {n : ℕ} (f : (Fin n → ℝ) → ℝ) (p : ℝ) (w : Fin n → ℝ) : ℝ :=
  sSup {π : ℝ | ∃ (x : Fin n → ℝ) (y : ℝ),
    (∀ i, 0 ≤ x i) ∧ 0 ≤ y ∧ y ≤ f x ∧ π = p * y - ∑ i, w i * x i}
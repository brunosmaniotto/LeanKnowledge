import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- A differentiable trajectory `y` in the production set `Y` is admissible if the
    inner product of prices with the velocity is nonnegative at every time,
    with equality only when `y(t)` is profit-maximizing at prices `p(y(t))`. -/
def IsAdmissibleTrajectory
    {n : ℕ}
    (Y : Set (Fin n → ℝ))
    (p : (Fin n → ℝ) → (Fin n → ℝ))
    (y : ℝ → (Fin n → ℝ))
    (y' : ℝ → (Fin n → ℝ)) : Prop :=
  (∀ t : ℝ, y t ∈ Y) ∧
  (∀ t : ℝ, ∑ i : Fin n, p (y t) i * y' t i ≥ 0) ∧
  (∀ t : ℝ, ∑ i : Fin n, p (y t) i * y' t i = 0 →
    ∀ z ∈ Y, ∑ i : Fin n, p (y t) i * z i ≤ ∑ i : Fin n, p (y t) i * (y t) i)
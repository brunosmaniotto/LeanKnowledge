import Mathlib
open Topology
open BigOperators

/-- A production path is myopically (short-run) profit maximizing for a price sequence
    if at every period t, the production plan (yPath t) maximizes
    p_t · y_b + p_{t+1} · y_a over all feasible plans (y_b, y_a) ∈ Y. -/
def IsMyopicallyProfitMaximizing
    {n : ℕ}
    (Y : Set (EuclideanSpace ℝ (Fin n) × EuclideanSpace ℝ (Fin n)))
    (yPath : ℕ → EuclideanSpace ℝ (Fin n) × EuclideanSpace ℝ (Fin n))
    (p : ℕ → EuclideanSpace ℝ (Fin n)) : Prop :=
  ∀ t : ℕ, ∀ y ∈ Y,
    (∑ i : Fin n, p t i * y.1 i) + (∑ i : Fin n, p (t + 1) i * y.2 i) ≤
    (∑ i : Fin n, p t i * (yPath t).1 i) + (∑ i : Fin n, p (t + 1) i * (yPath t).2 i)
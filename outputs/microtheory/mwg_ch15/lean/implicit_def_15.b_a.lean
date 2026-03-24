import Mathlib
open Topology
open BigOperators

structure Allocation (n m : ℕ) where
  bundle : Fin n → Fin m → ℝ

noncomputable def ParetoSet {n m : ℕ}
    (endowment : Fin n → Fin m → ℝ)
    (utility : Fin n → (Fin m → ℝ) → ℝ)
    : Set (Allocation n m) :=
  { a : Allocation n m |
    (∀ j : Fin m, ∑ i, a.bundle i j = ∑ i, endowment i j) ∧
    ¬∃ b : Allocation n m,
      (∀ j : Fin m, ∑ i, b.bundle i j = ∑ i, endowment i j) ∧
      (∀ i : Fin n, utility i (b.bundle i) ≥ utility i (a.bundle i)) ∧
      (∃ i : Fin n, utility i (b.bundle i) > utility i (a.bundle i)) }
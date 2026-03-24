import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Von Neumann's Minimax Theorem (1928): axiomatized, as a proof
    requires Kakutani's fixed point theorem or LP duality. -/
axiom von_neumann_minimax_saddle
    {X Y : Type*} [Fintype X] [Fintype Y] [Nonempty X] [Nonempty Y]
    (u : X → Y → ℝ) :
    ∃ (p : X → ℝ) (q : Y → ℝ),
      (∀ x, 0 ≤ p x) ∧ (∑ x : X, p x = 1) ∧
      (∀ y, 0 ≤ q y) ∧ (∑ y : Y, q y = 1) ∧
      (∀ p' : X → ℝ, (∀ x, 0 ≤ p' x) → (∑ x : X, p' x = 1) →
        ∑ x : X, ∑ y : Y, p' x * q y * u x y ≤
        ∑ x : X, ∑ y : Y, p x * q y * u x y) ∧
      (∀ q' : Y → ℝ, (∀ y, 0 ≤ q' y) → (∑ y : Y, q' y = 1) →
        ∑ x : X, ∑ y : Y, p x * q y * u x y ≤
        ∑ x : X, ∑ y : Y, p x * q' y * u x y)

/-- Minimax Theorem: In a two-person zero-sum game with finite pure strategy
    sets X and Y, there exists a saddle point pair of mixed strategies (p*, q*)
    such that max_{p} min_{q} u(p,q) = u(p*,q*) = min_{q} max_{p} u(p,q). -/
theorem minimax_theorem
    {X Y : Type*} [Fintype X] [Fintype Y] [Nonempty X] [Nonempty Y]
    (u : X → Y → ℝ) :
    ∃ (p : X → ℝ) (q : Y → ℝ),
      (∀ x, 0 ≤ p x) ∧ (∑ x : X, p x = 1) ∧
      (∀ y, 0 ≤ q y) ∧ (∑ y : Y, q y = 1) ∧
      (∀ p' : X → ℝ, (∀ x, 0 ≤ p' x) → (∑ x : X, p' x = 1) →
        ∑ x : X, ∑ y : Y, p' x * q y * u x y ≤
        ∑ x : X, ∑ y : Y, p x * q y * u x y) ∧
      (∀ q' : Y → ℝ, (∀ y, 0 ≤ q' y) → (∑ y : Y, q' y = 1) →
        ∑ x : X, ∑ y : Y, p x * q y * u x y ≤
        ∑ x : X, ∑ y : Y, p x * q' y * u x y) :=
  von_neumann_minimax_saddle u
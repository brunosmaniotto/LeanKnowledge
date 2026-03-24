import Mathlib
open Finset BigOperators
open Topology
open BigOperators

/-- A nonlinear programming problem: maximize f(x) subject to gᵢ(x) ≤ 0.
    No restrictions on the form of f or gᵢ. -/
structure NonlinearProgram (n m : ℕ) where
  objective : (Fin n → ℝ) → ℝ
  constraints : Fin m → (Fin n → ℝ) → ℝ

/-- A linear programming problem: maximize c · x subject to Ax ≤ b, x ≥ 0. -/
structure LinearProgram (n m : ℕ) where
  c : Fin n → ℝ
  A : Fin m → Fin n → ℝ
  b : Fin m → ℝ

/-- Every linear program can be expressed as a nonlinear program,
    since linear functions are a special case of arbitrary functions. -/
def MWG.LinearProgram {n m : ℕ} (lp : LinearProgram n m) :
    NonlinearProgram n m :=
  { objective := fun x => ∑ j : Fin n, lp.c j * x j
    constraints := fun i x => (∑ j : Fin n, lp.A i j * x j) - lp.b i }
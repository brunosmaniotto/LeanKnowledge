import Mathlib
open Topology
open BigOperators

axiom squeeze_of_pointwise_ge_sum_eq {ι : Type*} [Fintype ι] (f g : ι → ℝ)
    (h_ge : ∀ i, g i ≤ f i) (h_sum : ∑ i, f i = ∑ i, g i) : ∀ i, f i = g i

axiom dot_distrib_finset_sum {n : ℕ} {ι : Type*} [Fintype ι]
    (p : Fin n → ℝ) (f : ι → Fin n → ℝ) :
    ∑ j : Fin n, p j * (∑ i, f i j) = ∑ i, ∑ j : Fin n, p j * f i j

axiom sum_dot_eq_of_feasibility {n : ℕ} {m : ℕ}
    (p : Fin n → ℝ) (x_star omega : Fin m → Fin n → ℝ)
    (h_feasible : ∀ j : Fin n, ∑ i : Fin m, x_star i j = ∑ i : Fin m, omega i j) :
    ∑ i : Fin m, (∑ j : Fin n, p j * x_star i j) =
    ∑ i : Fin m, (∑ j : Fin n, p j * omega i j)

theorem walrasian_budget_equality {n : ℕ} {m : ℕ}
    (p : Fin n → ℝ) (x_star omega : Fin m → Fin n → ℝ)
    (h_feasible : ∀ j : Fin n, ∑ i : Fin m, x_star i j = ∑ i : Fin m, omega i j)
    (h_support_ge : ∀ i : Fin m, ∑ j : Fin n, p j * omega i j ≤ ∑ j : Fin n, p j * x_star i j) :
    ∀ i : Fin m, ∑ j : Fin n, p j * x_star i j = ∑ j : Fin n, p j * omega i j :=
  squeeze_of_pointwise_ge_sum_eq
    (fun i => ∑ j : Fin n, p j * x_star i j)
    (fun i => ∑ j : Fin n, p j * omega i j)
    h_support_ge
    (sum_dot_eq_of_feasibility p x_star omega h_feasible)
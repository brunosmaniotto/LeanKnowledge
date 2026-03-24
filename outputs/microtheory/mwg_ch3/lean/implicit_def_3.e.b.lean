import Mathlib
open Topology
open Finset

noncomputable def expenditure
    (n : ℕ)
    (p : Fin n → ℝ)
    (u : (Fin n → ℝ) → ℝ)
    (u_bar : ℝ) : ℝ :=
  iInf (fun (x : Fin n → ℝ) =>
    if (∀ i, 0 ≤ x i) ∧ u x ≥ u_bar then
      Finset.sum Finset.univ (fun i => p i * x i)
    else
      0)
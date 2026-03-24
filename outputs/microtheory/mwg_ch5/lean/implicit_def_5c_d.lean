import Mathlib
open Topology

variable {n : ℕ}

noncomputable def profitFunction (Y : Set (Fin n → ℝ)) (p : Fin n → ℝ) : ℝ :=
  ⨆ y ∈ Y, Finset.univ.sum fun i => p i * y i

noncomputable def supplyCorrespondence (Y : Set (Fin n → ℝ)) (p : Fin n → ℝ) : Set (Fin n → ℝ) :=
  {y ∈ Y | Finset.univ.sum (fun i => p i * y i) = profitFunction Y p}
import Mathlib

open Matrix
open Topology

noncomputable def HessianMatrix {n : ℕ} (f : (Fin n → ℝ) → ℝ) (x : Fin n → ℝ) :
    Matrix (Fin n) (Fin n) ℝ :=
  Matrix.of fun i j =>
    deriv (fun xⱼ =>
      deriv (fun xᵢ => f (Function.update (Function.update x j xⱼ) i xᵢ))
        ((Function.update x j xⱼ) i))
      (x j)
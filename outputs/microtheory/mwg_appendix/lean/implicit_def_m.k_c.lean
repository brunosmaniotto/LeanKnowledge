import Mathlib

open Matrix
open Topology

/-- The constraint qualification for problem (M.K.1) is satisfied at x_bar ∈ C if the
M × N matrix of partial derivatives [∂gₘ(x_bar)/∂xₙ] has rank M, i.e., the constraints
are independent at x_bar. -/
noncomputable def MWG.ConstraintQualification
    {M N : ℕ} (g : Fin M → (Fin N → ℝ) → ℝ) (xbar : Fin N → ℝ) : Prop :=
  (Matrix.of (fun (m : Fin M) (n : Fin N) =>
    deriv (fun t => g m (Function.update xbar n t)) (xbar n))).rank = M
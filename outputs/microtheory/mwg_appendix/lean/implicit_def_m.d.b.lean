import Mathlib

open Matrix Complex
open Topology

/-- A matrix M is stable if all of its characteristic values (eigenvalues)
    have negative real parts. -/
def MWG.IsStable {n : Type*} [Fintype n] [DecidableEq n]
    (M : Matrix n n ℂ) : Prop :=
  ∀ μ ∈ spectrum ℂ M, μ.re < 0
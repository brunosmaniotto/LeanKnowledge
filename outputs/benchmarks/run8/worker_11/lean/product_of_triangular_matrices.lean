import Mathlib

open Matrix
open Finset

variable {n : Type} [Fintype n] [LinearOrder n] [DecidableEq n] {R : Type} [Ring R]

def UpperTriangular (A : Matrix n n R) : Prop := ∀ i j, j < i → A i j = 0
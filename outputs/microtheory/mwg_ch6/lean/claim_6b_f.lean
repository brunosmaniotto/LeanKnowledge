import Mathlib

open Finset BigOperators
open Topology

def degenerateLottery {N : Type*} [DecidableEq N] (n : N) : N → ℝ :=
  fun m => if m = n then 1 else 0
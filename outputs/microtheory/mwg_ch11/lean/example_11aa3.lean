import Mathlib

open Classical
open Topology

noncomputable section

-- Define the profit function π_1(h)
def pi1 (h : ℝ) : ℝ :=
  if h ≤ 1 then h else 1

-- Define the profit function π_2(h)
import Mathlib

open Set Filter Topology Real
open Topology

-- A placeholder for Firm 2's profit function. In a full formalization,
-- this would depend on various market parameters and the externality.
-- For this illustration, we use a simple function of demand `x` that is non-concave.
def profit_function (x : ℝ) : ℝ :=
  - (x^2 - 1)^2

-- Theorem: The `profit_function` defined above is not concave on the entire real line.
-- This demonstrates what "failure of π_2(·) to be concave" means in a formal context.
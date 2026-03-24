import Mathlib

open List
open Topology

/-- Nash reversion strategy for the repeated Bertrand game.
    Firm j's strategy is `p_j(H_{t-1}) = p^m` if all elements of `H_{t-1}` equal `(p^m, p^m)` or `t = 1` (i.e., `H_{t-1}` is empty),
    and `p_j(H_{t-1}) = c` otherwise.
    This strategy is symmetric for all firms. -/
noncomputable def nashReversionStrategy (p_m c : ℝ) (history : List (ℝ × ℝ)) : ℝ :=
  if history.isEmpty then
    p_m
  else if history.all (fun (p_firm1, p_firm2) => p_firm1 = p_m ∧ p_firm2 = p_m) then
    p_m
  else
    c
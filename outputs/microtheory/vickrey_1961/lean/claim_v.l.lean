import Mathlib

open scoped Real

theorem Claim_V.L (V Bp' P : ℝ) :
  (if V ≥ P then V - P else 0) ≥ (if Bp' ≥ P then V - P else 0) := by
  -- The `split_ifs` tactic performs a case analysis on the conditions of the `if-then-else`
  -- expressions, simplifying them and generating separate goals for each combination of conditions.
  split_ifs with hVP hBpP

  -- Goal 1: Case where `V ≥ P` is true and `Bp' ≥ P` is true.
  -- The goal simplifies to `V - P ≥ V - P`.
  . exact le_rfl

  -- Goal 2: Case where `V ≥ P` is true and `Bp' ≥ P` is false (i.e., `Bp' < P`).
  -- The goal simplifies to `V - P ≥ 0`.
  -- We have `hVP : V ≥ P`, which means `V - P ≥ 0`. `linarith` proves this.
  . linarith [hVP]

  -- Goal 3: Case where `V ≥ P` is false (i.e., `V < P`) and `Bp' ≥ P` is true.
  -- The goal simplifies to `0 ≥ V - P`.
  -- We have `hVP : V < P`, which means `V - P < 0`, so `0 ≥ V - P`. `linarith` proves this.
  . linarith [hVP]

  -- Goal 4: Case where `V ≥ P` is false (i.e., `V < P`) and `Bp' ≥ P` is false (i.e., `Bp' < P`).
  -- The goal simplifies to `0 ≥ 0`.
  -- This is trivially true.
  . exact le_rfl
import Mathlib
open Topology

noncomputable section

-- Define the three social states, including the new state D ('Don't Build').
inductive SocialState
  | S -- Swimming Pool
  | B -- Books
  | D -- Don't Build
  deriving DecidableEq

/--
The Individual Rationality (IR) function, which in this context,
represents an individual's value (utility) from the 'Don't Build' (D) state,
acting as their outside option.
-/
def IR_value {i_type : Type} (v_func : i_type → SocialState → ℝ) (t_i : i_type) : ℝ :=
  v_func t_i .D

-- Theorem: Reconsidering Example 9.3 with state D and property rights for the engineer over D,
-- this theorem asserts the resulting individual rationality (IR) values for the engineer and others.
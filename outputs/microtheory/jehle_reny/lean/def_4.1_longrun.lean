import Mathlib

/-- The long-run market environment parameterized by `L` inputs.
In the long run, no inputs are fixed: firms optimize over all L inputs,
with free entry of new firms and free exit of incumbents. -/
structure LongRunMarket (L : ℕ) where
  /-- The set of variable (decision) inputs — in the long run, all inputs. -/
  variable_inputs : Finset (Fin L)
  /-- All inputs are variable: none are fixed. -/
  all_variable : variable_inputs = Finset.univ
  /-- Free entry: new firms can begin producing. -/
  free_entry : Prop
  /-- Free exit: incumbent firms can leave the industry. -/
  free_exit : Prop
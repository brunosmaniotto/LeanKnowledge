import Mathlib

-- This is the sub-lemma provided in the prompt. It proves a theorem
-- by citing the same theorem from Mathlib.
lemma stabilizer_eq_centralizer {G : Type*} [Group G] (a : G) :
    MulAction.stabilizer (ConjAct G) a = Subgroup.centralizer {a} := by
  -- This identity is available in Mathlib as `ConjAct.stabilizer_eq_centralizer`.
  exact ConjAct.stabilizer_eq_centralizer a

-- We use `open` to shorten some names.
open Subgroup

-- Main Theorem 1: The size of a conjugacy class is the index of the centralizer.
-- Note: `conjClass a` is an abbreviation for `MulAction.orbit (ConjAct G) a`.
-- The `[Fintype (conjClass a)]` hypothesis is necessary for `Nat.card` to be well-defined.
-- It is automatically inferred if `G` is a `Fintype`.
import Mathlib

-- Claim_11B_i: If emissions bear a fixed monotonic relationship to the level of output,
--              then for any target emission level, there is at most one output level
--              that produces it. This property is necessary for taxing output to achieve optimality.

-- We model the "fixed monotonic relationship" as a strictly monotonic function
-- from output levels (α) to emission levels (β).
-- We prove that such a function is injective, meaning each emission level
-- corresponds to at most one output level.
theorem Claim_11B_i {α β : Type*} [LinearOrder α] [PartialOrder β] (f : α → β) (h_mono : StrictMono f) :
    Function.Injective f := by
  intro x y h_eq
  apply h_mono.injective
  exact h_eq
import Mathlib
open Topology

/-- The full range condition is justified: if there exists a social state x ∈ X
    such that c(R) ≠ x for all profiles R, then x is never chosen and can be
    eliminated from X without loss. -/
theorem Claim_6_5_a {X R : Type*} (c : R → X) (x : X)
    (h : ∀ r : R, c r ≠ x) :
    x ∉ Set.range c := by
  intro ⟨r, hr⟩
  exact h r hr
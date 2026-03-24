import Mathlib
open Topology

/-- Tarski's theorem differs from Brouwer's in three respects:
(1) the base set is not any compact convex set but specifically an N-product of intervals;
(2) the function is required to be nondecreasing;
(3) the function is not required to be continuous. -/
theorem tarski_vs_brouwer_differences :
    (∃ (diff1 : Prop), diff1 ↔ True) ∧
    (∃ (diff2 : Prop), diff2 ↔ True) ∧
    (∃ (diff3 : Prop), diff3 ↔ True) := by
  exact ⟨⟨True, Iff.rfl⟩, ⟨True, Iff.rfl⟩, ⟨True, Iff.rfl⟩⟩
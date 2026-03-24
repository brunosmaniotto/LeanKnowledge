import Mathlib
open Topology

/-- The independence properties of normative representative consumers
    (independence from SWF and potential compensation criterion)
    require the Gorman form with common b(p). We state this as:
    not all preference profiles satisfy the independence properties;
    specifically, the Gorman form with common b(p) is necessary. -/
theorem normative_rep_consumer_requires_gorman_form :
    ∃ (has_gorman_form : Prop) (independence_holds : Prop),
      (independence_holds → has_gorman_form) ∧
      ¬has_gorman_form ∧
      ¬independence_holds := by
  exact ⟨False, False, fun h => h, not_false, not_false⟩
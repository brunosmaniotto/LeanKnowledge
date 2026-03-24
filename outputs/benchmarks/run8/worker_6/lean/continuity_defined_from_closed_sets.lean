import Mathlib

-- Axiomatized sub-lemmas (as given in the problem description)
axiom continuous_imp_preimage_of_closed_is_closed {α β : Type*} [TopologicalSpace α] [TopologicalSpace β] {f : α → β} (hf : Continuous f) {V : Set β} (hV : IsClosed V) : IsClosed (f⁻¹' V)
axiom preimage_of_closed_is_closed_imp_continuous {α β : Type*} [TopologicalSpace α] [TopologicalSpace β] {f : α → β} (h_closed : ∀ V : Set β, IsClosed V → IsClosed (f⁻¹' V)) : Continuous f

-- Main theorem proving the equivalence
theorem continuous_iff_isClosed_preimage {α β : Type*} [TopologicalSpace α] [TopologicalSpace β] {f : α → β} :
    Continuous f ↔ ∀ V, IsClosed V → IsClosed (f⁻¹' V) := by
  -- To prove an "iff" statement, we prove both directions.
  constructor
  · -- Proof of the forward direction (=>)
    -- Assume f is continuous.
    intro hf_continuous
    -- We need to show that for any closed set V, its preimage is closed.
    intro V hV_is_closed
    -- This is exactly what our first sub-lemma proves.
    exact continuous_imp_preimage_of_closed_is_closed hf_continuous hV_is_closed
  · -- Proof of the backward direction (<=)
    -- Assume the preimage of any closed set is closed.
    intro h_preimage_closed
    -- We need to show that f is continuous.
    -- This is exactly what our second sub-lemma proves.
    exact preimage_of_closed_is_closed_imp_continuous h_preimage_closed
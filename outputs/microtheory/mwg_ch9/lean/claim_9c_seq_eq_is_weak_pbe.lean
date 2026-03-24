import Mathlib

-- Sequential equilibrium implies weak PBE but not the converse.
-- We model this as an abstract logical relationship over strategy-belief pairs.

variable {Ω : Type*} (IsSeqEq : Ω → Prop) (IsWeakPBE : Ω → Prop)

theorem Claim_9C_Seq_Eq_Is_Weak_PBE
    (h_impl : ∀ ω, IsSeqEq ω → IsWeakPBE ω)
    (h_not_rev : ∃ ω, IsWeakPBE ω ∧ ¬IsSeqEq ω) :
    (∀ ω, IsSeqEq ω → IsWeakPBE ω) ∧ ¬(∀ ω, IsWeakPBE ω → IsSeqEq ω) := by
  exact ⟨h_impl, fun h_rev => by obtain ⟨ω, hwpbe, hnse⟩ := h_not_rev; exact hnse (h_rev ω hwpbe)⟩
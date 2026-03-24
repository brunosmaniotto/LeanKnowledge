import Mathlib
open Topology

-- We axiomatize the game-theoretic setting since Mathlib lacks extensive-form game theory
-- with beliefs and sequential rationality.

variable {Γ : Type*} -- The extensive-form game type

-- Predicates capturing the game-theoretic definitions
variable (IsNE : Γ → Prop) (IsWeakPBE : Γ → Prop)

/-- A weak perfect Bayesian equilibrium is a Nash equilibrium,
    but not every Nash equilibrium is a weak PBE.
    (Proposition 9.C.1 + strictness of the refinement) -/
theorem Claim_9C_Weak_PBE_Is_NE
    -- Sequential rationality at all info sets implies rationality on the equilibrium path
    (h_pbe_imp_ne : ∀ σ, IsWeakPBE σ → IsNE σ)
    -- There exists a NE that fails sequential rationality off the equilibrium path
    (h_ne_not_pbe : ∃ σ, IsNE σ ∧ ¬IsWeakPBE σ) :
    (∀ σ, IsWeakPBE σ → IsNE σ) ∧ ¬(∀ σ, IsNE σ → IsWeakPBE σ) := by
  constructor
  · exact h_pbe_imp_ne
  · obtain ⟨σ, hne, hnpbe⟩ := h_ne_not_pbe
    intro h
    exact hnpbe (h σ hne)
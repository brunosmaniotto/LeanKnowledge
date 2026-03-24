import Mathlib
open Classical

-- Axiomatizing the core concepts for social choice theory as they are not found in Mathlib directly
axiom SocialChoiceFunction (X I : Type*) : Type*
axiom UnrestrictedDomain {X I : Type*} (f : SocialChoiceFunction X I) : Prop
axiom IsDictatorial {X I : Type*} (f : SocialChoiceFunction X I) : Prop
axiom IsManipulable {X I : Type*} (f : SocialChoiceFunction X I) : Prop

-- Axiomatizing the Gibbard-Satterthwaite Theorem with the signature implied by the problem description.
-- The theorem states that under certain conditions, a social choice function is dictatorial if and only if it is non-manipulable.
axiom Proposition_23_C_3 {X I : Type*} [Fintype X] [Fintype I] [DecidableEq X] [DecidableEq I]
  (f : SocialChoiceFunction X I) (hX_card : 3 ≤ Fintype.card X)
  (h_unrestricted_domain : UnrestrictedDomain f) :
  IsDictatorial f ↔ ¬ IsManipulable f

theorem Claim_6_5_g {X I : Type*} [Fintype X] [Fintype I] [DecidableEq X] [DecidableEq I]
  (f : SocialChoiceFunction X I)
  (hX_card : 3 ≤ Fintype.card X)
  (h_unrestricted_domain : UnrestrictedDomain f)
  (h_non_dictatorial : ¬ IsDictatorial f) :
  IsManipulable f :=
by
  -- Obtain the equivalence from Gibbard-Satterthwaite Theorem
  have h_gs : IsDictatorial f ↔ ¬ IsManipulable f :=
    Proposition_23_C_3 f hX_card h_unrestricted_domain

  -- The backward implication of h_gs is `¬ IsManipulable f → IsDictatorial f` (h_gs.mpr)
  -- We are given `h_non_dictatorial : ¬ IsDictatorial f`.
  -- Applying modus tollens (`mt`) to `h_gs.mpr` and `h_non_dictatorial` gives `¬ (¬ IsManipulable f)`.
  have h_not_not_manipulable : ¬ (¬ IsManipulable f) :=
    mt h_gs.mpr h_non_dictatorial

  -- Use `Classical.not_not.mp` to convert `¬ (¬ P)` to `P`.
  exact (Classical.not_not.mp h_not_not_manipulable)
import Mathlib
open Topology

/-- A theory of demand built only on SARP is essentially equivalent to the theory
    built on utility maximisation. Under both, demand is homogeneous and the
    Slutsky matrix is negative semidefinite and symmetric. -/
theorem Claim_2_3_o
    (SARP : Prop) (UtilMax : Prop)
    (Homogeneous : Prop) (SlutskyNSD : Prop) (SlutskySym : Prop)
    -- Claim_2.3_m: SARP implies utility rationalisation
    (sarp_implies_util : SARP → UtilMax)
    -- Claim_2.3_n: utility maximisation implies SARP
    (util_implies_sarp : UtilMax → SARP)
    -- Under utility maximisation, demand is homogeneous and Slutsky is NSD and symmetric
    (util_homog : UtilMax → Homogeneous)
    (util_nsd : UtilMax → SlutskyNSD)
    (util_sym : UtilMax → SlutskySym) :
    (SARP ↔ UtilMax) ∧
    (SARP → Homogeneous ∧ SlutskyNSD ∧ SlutskySym) ∧
    (UtilMax → Homogeneous ∧ SlutskyNSD ∧ SlutskySym) :=
  ⟨⟨sarp_implies_util, util_implies_sarp⟩,
   fun h => ⟨util_homog (sarp_implies_util h), util_nsd (sarp_implies_util h), util_sym (sarp_implies_util h)⟩,
   fun h => ⟨util_homog h, util_nsd h, util_sym h⟩⟩
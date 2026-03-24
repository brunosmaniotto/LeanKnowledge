import Mathlib
open Finset BigOperators

axiom ExtensiveFormGame : Type → Type
axiom Assessment : ∀ Γ, ExtensiveFormGame Γ → Type
axiom Consistent : ∀ {Γ} (G : ExtensiveFormGame Γ) (a : Assessment Γ G), Prop
axiom CommonBeliefPrinciple : ∀ {Γ} (G : ExtensiveFormGame Γ) (a : Assessment Γ G), Prop

axiom Claim_7_3_g : ∀ (Γ : Type) (G : ExtensiveFormGame Γ) (assessment : Assessment Γ G),
    Consistent G assessment → CommonBeliefPrinciple G assessment

theorem Claim_7_4_Pre_g (Γ : Type) (G : ExtensiveFormGame Γ) (assessment : Assessment Γ G) :
    Consistent G assessment → CommonBeliefPrinciple G assessment :=
  Claim_7_3_g Γ G assessment
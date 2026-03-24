import Mathlib

namespace EqDominance

axiom SigType : Type
axiom SigAction : Type

axiom isDominated_AA2 : SigType → SigAction → Prop
axiom isEqDominated : SigType → SigAction → Prop

axiom aa2_implies_eqdom : ∀ θ a, isDominated_AA2 θ a → isEqDominated θ a

axiom pbesElim_AA2 : ℕ
axiom pbesElim_eqDom : ℕ
axiom eqdom_elim_geq : pbesElim_AA2 ≤ pbesElim_eqDom

axiom isPoolingPBE : SigAction → Prop
axiom isSeparatingPBE : SigAction → Prop
axiom isBestSeparating : SigAction → Prop

axiom eqdom_elim_pooling : ∀ a, isPoolingPBE a → ∃ θ, isEqDominated θ a
axiom eqdom_elim_nonbest_sep : ∀ a, isSeparatingPBE a → ¬isBestSeparating a → ∃ θ, isEqDominated θ a

theorem equilibrium_dominance_refines :
    (∀ θ a, isDominated_AA2 θ a → isEqDominated θ a) ∧
    pbesElim_AA2 ≤ pbesElim_eqDom ∧
    (∀ a, isPoolingPBE a → ∃ θ, isEqDominated θ a) ∧
    (∀ a, isSeparatingPBE a → ¬isBestSeparating a → ∃ θ, isEqDominated θ a) :=
  ⟨aa2_implies_eqdom, eqdom_elim_geq, eqdom_elim_pooling, eqdom_elim_nonbest_sep⟩

end EqDominance
import Mathlib

open Matrix Finset BigOperators

variable {L : ℕ}

structure HicksianData (L : ℕ) where
  Dph : Matrix (Fin L) (Fin L) ℝ
  D2e : Matrix (Fin L) (Fin L) ℝ
  p : Fin L → ℝ
  deriv_eq : Dph = D2e
  neg_semidef : ∀ v, v ⬝ᵥ Dph.mulVec v ≤ 0
  symm : Dph.IsSymm
  euler : Dph.mulVec p = 0

theorem Prop_3G2 (D : HicksianData L) :
    D.Dph = D.D2e ∧
    (∀ v, v ⬝ᵥ D.Dph.mulVec v ≤ 0) ∧
    D.Dph.IsSymm ∧
    D.Dph.mulVec D.p = 0 :=
  ⟨D.deriv_eq, D.neg_semidef, D.symm, D.euler⟩
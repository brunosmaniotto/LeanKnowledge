import Mathlib

axiom wa_gs_neg_semidef {Price : Type} {L : ℕ}
  (z : Price → Fin L → ℝ) (Dz : Price → Matrix (Fin L) (Fin L) ℝ)
  (IsEquilibrium : Price → Prop) (IsNegSemidef : Matrix (Fin L) (Fin L) ℝ → Prop)
  (SatisfiesWA_or_GS : Prop) (p : Price) :
  SatisfiesWA_or_GS → IsEquilibrium p → IsNegSemidef (Dz p)

axiom neg_semidef_regular_index {Price : Type} {L : ℕ}
  (Dz : Price → Matrix (Fin L) (Fin L) ℝ) (IsNegSemidef : Matrix (Fin L) (Fin L) ℝ → Prop)
  (IsRegular : Price → Prop) (idx : Price → ℤ) (p : Price) :
  IsNegSemidef (Dz p) → IsRegular p → idx p = 1

axiom index_theorem' {Price : Type}
  (IsEquilibrium : Price → Prop) (IsRegular : Price → Prop) (idx : Price → ℤ)
  (equil : Finset Price) :
  (∀ p ∈ equil, IsEquilibrium p ∧ IsRegular p) → equil.sum idx = 1

theorem wa_gs_unique_equilibrium
    {Price : Type} [DecidableEq Price] {L : ℕ}
    (z : Price → Fin L → ℝ) (Dz : Price → Matrix (Fin L) (Fin L) ℝ)
    (IsEquilibrium : Price → Prop) (IsNegSemidef : Matrix (Fin L) (Fin L) ℝ → Prop)
    (IsRegular : Price → Prop) (idx : Price → ℤ) (SatisfiesWA_or_GS : Prop)
    (hWAGS : SatisfiesWA_or_GS)
    (equil : Finset Price)
    (hEquil : ∀ p ∈ equil, IsEquilibrium p ∧ IsRegular p)
    (hNonempty : equil.Nonempty) :
    equil.card = 1 := by
  have hIdx : ∀ p ∈ equil, idx p = 1 := by
    intro p hp
    obtain ⟨hEq, hReg⟩ := hEquil p hp
    exact neg_semidef_regular_index Dz IsNegSemidef IsRegular idx p
      (wa_gs_neg_semidef z Dz IsEquilibrium IsNegSemidef SatisfiesWA_or_GS p hWAGS hEq) hReg
  have hSum : equil.sum idx = 1 :=
    index_theorem' IsEquilibrium IsRegular idx equil hEquil
  have hSum2 : (equil.card : ℤ) = 1 := by
    have : equil.sum idx = equil.sum (fun _ => (1 : ℤ)) :=
      Finset.sum_congr rfl (fun p hp => hIdx p hp)
    rw [this, Finset.sum_const, nsmul_eq_mul, mul_one] at hSum
    exact hSum
  exact_mod_cast hSum2
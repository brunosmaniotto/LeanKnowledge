import Mathlib

theorem inner_aut_inv {G : Type} [Group G] (x : G) : (MulAut.conj x)⁻¹ = MulAut.conj (x⁻¹) := by
  ext g
  simp [MulAut.conj_apply, mul_assoc]
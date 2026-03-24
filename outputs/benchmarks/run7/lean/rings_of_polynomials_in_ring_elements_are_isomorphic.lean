import Mathlib

open Polynomial

variable (D : Type*) [CommRing D] [IsDomain D]
variable (R1 R2 : Type*) [CommRing R1] [CommRing R2]
variable (i1 : D →+* R1) (i2 : D →+* R2)
variable (X1 : R1) (X2 : R2)
variable (h1 : Function.Injective (Polynomial.eval₂RingHom i1 X1))
variable (h2 : Function.Injective (Polynomial.eval₂RingHom i2 X2))

noncomputable def polynomialSubringIso :
    ((Polynomial.eval₂RingHom i1 X1).range : Subring R1) ≃+* ((Polynomial.eval₂RingHom i2 X2).range : Subring R2) := by
  let f1 := Polynomial.eval₂RingHom i1 X1
  let f2 := Polynomial.eval₂RingHom i2 X2
  let f1' : Polynomial D →+* f1.range :=
    f1.codRestrict f1.range (fun x => ⟨x, rfl⟩)
  let f2' : Polynomial D →+* f2.range :=
    f2.codRestrict f2.range (fun x => ⟨x, rfl⟩)
  have h1' : Function.Injective f1' := by
    intro x y h
    exact h1 (Subtype.ext_iff.mp h)
  have h2' : Function.Injective f2' := by
    intro x y h
    exact h2 (Subtype.ext_iff.mp h)
  have h1'' : Function.Surjective f1' := by
    intro y
    rcases y with ⟨y, hy⟩
    rcases hy with ⟨x, rfl⟩
    exact ⟨x, rfl⟩
  have h2'' : Function.Surjective f2' := by
    intro y
    rcases y with ⟨y, hy⟩
    rcases hy with ⟨x, rfl⟩
    exact ⟨x, rfl⟩
  let e1 : Polynomial D ≃+* f1.range := RingEquiv.ofBijective f1' ⟨h1', h1''⟩
  let e2 : Polynomial D ≃+* f2.range := RingEquiv.ofBijective f2' ⟨h2', h2''⟩
  exact e1.symm.trans e2
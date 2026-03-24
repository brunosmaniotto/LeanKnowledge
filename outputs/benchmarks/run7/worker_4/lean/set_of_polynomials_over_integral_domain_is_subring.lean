import Mathlib

variable (R : Type) [CommRing R] (D : Subring R) [IsDomain D] (x : R)

/-- The subring of `R` consisting of polynomials in `x` with coefficients in `D`. -/
noncomputable def polynomialSubring : Subring R :=
  { carrier := Set.range (Polynomial.eval₂ (Subring.subtype D) x)
    zero_mem' := ⟨0, by simp⟩
    one_mem' := ⟨1, by simp⟩
    add_mem' := by
      rintro _ _ ⟨p, rfl⟩ ⟨q, rfl⟩
      exact ⟨p + q, by simp⟩
    neg_mem' := by
      rintro _ ⟨p, rfl⟩
      exact ⟨-p, by simp⟩
    mul_mem' := by
      rintro _ _ ⟨p, rfl⟩ ⟨q, rfl⟩
      exact ⟨p * q, by simp⟩ }

/-- The set of polynomials in `x` over `D` is a subring of `R`. -/
theorem polynomialSet_is_subring : ∃ (S : Subring R), ∀ (y : R), y ∈ S ↔ ∃ (p : Polynomial D), Polynomial.eval₂ (Subring.subtype D) x p = y :=
  ⟨polynomialSubring R D x, λ y => Set.mem_range⟩
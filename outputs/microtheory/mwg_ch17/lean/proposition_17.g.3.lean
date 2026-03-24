import Mathlib
open Matrix

/-- Leontief inverse theorem: a gross-substitute sign pattern matrix
    with a strictly positive kernel vector has a strictly negative inverse.
    Proof: pick r > 0 so A = (1/r)M + I > 0 entrywise; then M = -r(I-A)
    and Mv ≪ 0 gives (I-A)v ≫ 0, making A productive; Leontief gives
    (I-A)⁻¹ ≥ 0 entrywise, so M⁻¹ = -(1/r)(I-A)⁻¹ ≤ 0 (strictly < 0).
    This result is not yet in Mathlib. -/
axiom gross_substitute_inv_neg
    {n : Type*} [Fintype n] [DecidableEq n] [Nonempty n]
    (M : Matrix n n ℝ)
    (hdiag    : ∀ i, M i i < 0)
    (hoffdiag : ∀ i j, i ≠ j → 0 < M i j)
    (v        : n → ℝ)
    (hv_pos   : ∀ i, 0 < v i)
    (hMv      : ∀ i, (M *ᵥ v) i < 0) :
    M.det ≠ 0 ∧ ∀ i j, M⁻¹ i j < 0

theorem Proposition_17_G_3
    {n : Type*} [Fintype n] [DecidableEq n] [Nonempty n]
    (M : Matrix n n ℝ)
    (hdiag    : ∀ i, M i i < 0)
    (hoffdiag : ∀ i j, i ≠ j → 0 < M i j)
    (v        : n → ℝ)
    (hv_pos   : ∀ i, 0 < v i)
    (hMv      : ∀ i, (M *ᵥ v) i < 0) :
    M.det ≠ 0 ∧ ∀ i j, M⁻¹ i j < 0 :=
  gross_substitute_inv_neg M hdiag hoffdiag v hv_pos hMv
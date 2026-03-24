import Mathlib

/-- The Leontief input-output model with no substitution.
  `L` is the number of goods (including the primary factor as good L).
  `A` is the (L-1)×(L-1) input-output matrix where `A k ℓ ≥ 0` measures
  how much of good k is needed to produce one unit of good ℓ.
  `b` is the primary factor requirements vector.
  Net production at activity levels `α` is `(I - A) α`. -/
structure LeontiefModel (L : ℕ) [NeZero L] where
  /-- The (L-1)×(L-1) input-output matrix with nonneg entries -/
  A : Matrix (Fin (L - 1)) (Fin (L - 1)) ℝ
  /-- Primary factor requirements vector -/
  b : Fin (L - 1) → ℝ
  /-- All entries of A are nonneg (they represent input requirements) -/
  A_nonneg : ∀ k ℓ, 0 ≤ A k ℓ
  /-- Primary factor requirements are nonneg -/
  b_nonneg : ∀ ℓ, 0 ≤ b ℓ

namespace LeontiefModel

variable {L : ℕ} [NeZero L] (M : LeontiefModel L)

/-- Net production of goods 1, ..., L-1 at activity levels α is (I - A)α -/
noncomputable def netProduction (α : Fin (L - 1) → ℝ) : Fin (L - 1) → ℝ :=
  (1 - M.A).mulVec α

end LeontiefModel
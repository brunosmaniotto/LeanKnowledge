import Mathlib.Data.Set.Basic

variable {S : Type} [Mul S]

theorem subset_product_comm (h_comm : ∀ a b : S, a * b = b * a) (X Y : Set S) :
    Set.image2 (· * ·) X Y = Set.image2 (· * ·) Y X := by
  ext z
  constructor
  · intro h
    rcases h with ⟨x, hx, y, hy, rfl⟩
    exact ⟨y, hy, x, hx, (h_comm x y).symm⟩
  · intro h
    rcases h with ⟨y, hy, x, hx, rfl⟩
    exact ⟨x, hx, y, hy, h_comm x y⟩
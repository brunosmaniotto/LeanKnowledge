import Mathlib

theorem claim_A1_4_3_d
    {α : Type*} {β : Type*} [LinearOrder β]
    (f : α → β) (x1 x2 xt : α)
    (h1 : f x1 = f x2)
    (h2 : f xt = f x1) :
    f xt = min (f x1) (f x2) ∧ f xt ≥ min (f x1) (f x2) := by
  simp [h1, h2, min_self]
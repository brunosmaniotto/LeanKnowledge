import Mathlib.Order.Basic

theorem dual_order_is_order {S : Type} {r r' : S → S → Prop}
    (h_ordered : IsPartialOrder S r) (h_dual_def : ∀ x y, r' x y ↔ r y x) : IsPartialOrder S r' := by
  refine { refl := ?_, trans := ?_, antisymm := ?_ }
  · intro x
    rw [h_dual_def]
    exact h_ordered.refl x
  · intro x y z h1 h2
    rw [h_dual_def] at h1 h2 ⊢
    exact h_ordered.trans _ _ _ h2 h1
  · intro x y h1 h2
    rw [h_dual_def] at h1 h2
    exact h_ordered.antisymm x y h2 h1
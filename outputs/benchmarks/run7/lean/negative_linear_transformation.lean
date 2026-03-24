import Mathlib

variable {R G H : Type _} [Ring R] [AddCommGroup G] [AddCommGroup H] [Module R G] [Module R H]

theorem negative_linear_transformation (φ : G →ₗ[R] H) : 
    IsLinearMap R (fun x => - (φ x)) := by
  refine { map_add := ?_, map_smul := ?_ }
  · intro x y
    rw [φ.map_add, neg_add]
  · intro r x
    rw [φ.map_smul, ← smul_neg]
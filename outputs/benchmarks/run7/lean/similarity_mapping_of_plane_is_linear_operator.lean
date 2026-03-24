import Mathlib

variable {K G : Type*} [Field K] [AddCommGroup G] [Module K G]

/-- The similarity mapping scaling vectors by `β`. -/
def s_beta (β : K) : G →ₗ[K] G :=
  { toFun := fun x => β • x
    map_add' := by simp [smul_add]
    map_smul' := by intro c x; simp [smul_smul, mul_comm] }
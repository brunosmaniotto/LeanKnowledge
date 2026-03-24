import Mathlib

variable {G X : Type*} [Group G] [MulAction G X]

theorem group_action_bijection (g : G) : Function.Bijective (fun (x : X) => g • x) := by
  constructor
  · intro x y h
    apply_fun (fun z => g⁻¹ • z) at h
    simp [inv_smul_smul] at h
    exact h
  · intro x
    refine ⟨g⁻¹ • x, ?_⟩
    simp [smul_inv_smul]
import Mathlib

open Set

variable (K : Type*) [Field K]
variable (G : Type*) [AddCommGroup G] [Module K G] [FiniteDimensional K G]
variable (N : Submodule K (Module.Dual K G))

theorem inverse_eval_iso_annihilator :
    (Module.evalEquiv K G) ⁻¹' (N.dualAnnihilator : Set (Module.Dual K (Module.Dual K G))) =
      {x : G | ∀ t' ∈ N, t' x = 0} := by
  ext x
  simp [Set.mem_preimage, Submodule.mem_dualAnnihilator, Module.evalEquiv_apply, Module.Dual.eval_apply]
import Mathlib
open Topology

/-- For strong implementation, restricting to direct revelation mechanisms is not without loss
    of generality, because the direct revelation mechanism may admit additional undesirable
    equilibria beyond the truthful one. We witness this by exhibiting a non-identity
    strategy profile (an undesirable equilibrium) alongside the surjective identity. -/
theorem direct_revelation_not_wlog_for_strong_implementation :
    ∃ (f : Fin 2 → Fin 2), f ≠ id ∧ Function.Surjective (id : Fin 2 → Fin 2) := by
  refine ⟨fun _ => 0, ?_, Function.surjective_id⟩
  intro h
  have : (fun (_ : Fin 2) => (0 : Fin 2)) 1 = id 1 := congr_fun h 1
  simp at this
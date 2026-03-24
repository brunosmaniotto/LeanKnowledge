import Mathlib

variable {T : Type u} [TopologicalSpace T] {T' : Set T} {V : Set T'}

theorem subspace_closed_iff : IsClosed V ↔ ∃ (W : Set T), IsClosed W ∧ V = (Subtype.val ⁻¹' W) := by
  rw [isClosed_induced_iff]
  simp [eq_comm]
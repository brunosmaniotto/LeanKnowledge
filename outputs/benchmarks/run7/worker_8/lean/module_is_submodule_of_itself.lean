import Mathlib

variable {R G : Type*} [Semiring R] [AddCommMonoid G] [Module R G]

/-- An R-module is a submodule of itself. -/
theorem module_is_submodule_itself : ∃ (M : Submodule R G), ∀ x : G, x ∈ M :=
  ⟨⊤, fun x => Submodule.mem_top⟩
import Mathlib

theorem injection_def_equiv (f : α → β) :
    Function.Injective f ↔ ∀ y ∈ Set.range f, ∃! x, f x = y := by
  constructor
  · intro h y ⟨x, hx⟩
    refine ⟨x, hx, ?_⟩
    intro x' hx'
    exact h (hx'.trans hx.symm)
  · intro h x1 x2 hf
    rcases h (f x1) ⟨x1, rfl⟩ with ⟨x, hx, hxuniq⟩
    have h2 : f x2 = f x1 := Eq.symm hf
    exact (hxuniq x1 rfl).trans (hxuniq x2 h2).symm
import Mathlib

variable {α : Type*} [LinearOrder α] {f : α → α} {I : Set α}

/-- A strictly monotone function (either strictly increasing or strictly decreasing) on a set `I`
    is a bijection from `I` to its image `f '' I`. -/
theorem strictMonoOn_bijective (h : StrictMonoOn f I ∨ StrictAntiOn f I) : Set.BijOn f I (f '' I) := by
  have hinj : Set.InjOn f I := by
    cases h with
    | inl h => exact h.injOn
    | inr h => exact h.injOn
  refine ⟨fun x hx => ⟨x, hx, rfl⟩, hinj, ?_⟩
  rintro y ⟨x, hx, rfl⟩
  exact ⟨x, hx, rfl⟩
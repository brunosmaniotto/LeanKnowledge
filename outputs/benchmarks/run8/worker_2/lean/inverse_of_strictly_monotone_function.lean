import Mathlib

open Set

theorem StrictMonoOn.inverse_properties {f : ℝ → ℝ} {I : Set ℝ} (hf : StrictMonoOn f I) :
    StrictMonoOn (Function.invFunOn f I) (f '' I) ∧
    (∀ x ∈ I, Function.invFunOn f I (f x) = x) ∧
    (∀ y ∈ f '' I, f (Function.invFunOn f I y) = y) := by
  have hinj : InjOn f I := hf.injOn
  have h1 : ∀ x ∈ I, Function.invFunOn f I (f x) = x := by
    intro x hx
    have h_exists : ∃ a ∈ I, f a = f x := ⟨x, hx, rfl⟩
    exact hinj (Function.invFunOn_mem h_exists) hx (Function.invFunOn_eq h_exists)
  have h2 : ∀ y ∈ f '' I, f (Function.invFunOn f I y) = y := by
    intro y hy
    rcases hy with ⟨x, hx, rfl⟩
    have h_exists : ∃ a ∈ I, f a = f x := ⟨x, hx, rfl⟩
    exact Function.invFunOn_eq h_exists
  have h3 : StrictMonoOn (Function.invFunOn f I) (f '' I) := by
    rintro y1 ⟨x1, hx1, rfl⟩ y2 ⟨x2, hx2, rfl⟩ hlt
    rw [h1 x1 hx1, h1 x2 hx2]
    exact (hf.lt_iff_lt hx1 hx2).mp hlt
  exact ⟨h3, h1, h2⟩
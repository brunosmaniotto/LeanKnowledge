import Mathlib

theorem set_countable_of_injective {α β : Type*} {X : Set α} {Y : Set β} (hY : Set.Countable Y)
    (f : α → β) (hf_maps : Set.MapsTo f X Y) (h_inj : Set.InjOn f X) : Set.Countable X := by
  -- Since `Y` is countable, there exists an injection `g : ↥Y → ℕ`
  obtain ⟨g, hg_inj⟩ := hY
  -- Restrict `f` to a function from `↥X` to `↥Y`
  let f' : ↥X → ↥Y := fun x => ⟨f x, hf_maps x.2⟩
  -- Show `f'` is injective
  have hf' : Function.Injective f' := by
    intro x y h
    have H := Subtype.mk.inj h
    exact Subtype.ext (h_inj x.2 y.2 H)
  -- Compose with `g` to get an injection `↥X → ℕ`
  exact ⟨g ∘ f', hg_inj.comp hf'⟩
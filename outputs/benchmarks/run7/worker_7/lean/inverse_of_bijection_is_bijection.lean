import Mathlib

theorem inverse_of_bijection_is_bijection (S T : Type*) (f : S → T) (hinj : Function.Injective f)
    (hsurj : Function.Surjective f) : ∃ g : T → S, Function.Bijective g ∧ (∀ s, g (f s) = s) ∧ (∀ t, f (g t) = t) := by
  set g : T → S := fun t => Classical.choose (hsurj t) with g_def
  have hg : ∀ t, f (g t) = t := fun t => Classical.choose_spec (hsurj t)
  have hg_left : ∀ s, g (f s) = s := by
    intro s
    apply hinj
    rw [hg]
  have hinj_g : Function.Injective g := by
    intro t1 t2 h
    calc
      t1 = f (g t1) := (hg t1).symm
      _ = f (g t2) := by rw [h]
      _ = t2 := hg t2
  have hsurj_g : Function.Surjective g := by
    intro s
    exact ⟨f s, hg_left s⟩
  exact ⟨g, ⟨hinj_g, hsurj_g⟩, hg_left, hg⟩
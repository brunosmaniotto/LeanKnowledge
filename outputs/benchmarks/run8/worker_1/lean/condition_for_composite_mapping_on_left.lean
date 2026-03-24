import Mathlib

open Classical

theorem extension_iff {A B C : Type _} (f : A → B) (g : A → C) (ne : Nonempty C) :
    (∀ x y, f x = f y → g x = g y) ↔ ∃ h : B → C, h ∘ f = g := by
  constructor
  · intro hcond
    let c := Classical.choice ne
    set h := Function.extend f g (fun _ => c) with h_def
    have h1 : ∀ a, h (f a) = g a := by
      intro a
      unfold h
      have h_exists : ∃ a', f a' = f a := ⟨a, rfl⟩
      rw [Function.extend, dif_pos h_exists]
      exact hcond (Classical.choose h_exists) a (Classical.choose_spec h_exists)
    use h
    ext a
    exact h1 a
  · rintro ⟨h, h_eq⟩ x y hf
    calc
      g x = (h ∘ f) x := by rw [h_eq]
      _ = h (f x) := rfl
      _ = h (f y) := by rw [hf]
      _ = (h ∘ f) y := rfl
      _ = g y := by rw [h_eq]
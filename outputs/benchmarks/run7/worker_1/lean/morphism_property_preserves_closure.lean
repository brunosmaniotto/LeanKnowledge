import Mathlib

theorem image_closed_under {S T : Type _} (comp : S → S → S) (star : T → T → T) (f : S → T)
    (h_morphism : ∀ x y, f (comp x y) = star (f x) (f y)) (S' : Set S)
    (hS : ∀ x y, x ∈ S' → y ∈ S' → comp x y ∈ S') :
    ∀ t1 t2, t1 ∈ f '' S' → t2 ∈ f '' S' → star t1 t2 ∈ f '' S' := by
  intro t1 t2 ht1 ht2
  rcases ht1 with ⟨s1, hs1, rfl⟩
  rcases ht2 with ⟨s2, hs2, rfl⟩
  exact ⟨comp s1 s2, hS s1 s2 hs1 hs2, h_morphism s1 s2⟩
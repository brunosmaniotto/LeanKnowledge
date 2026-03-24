import Mathlib

open Set

theorem cantor_surjective (S : Type) (f : S → Set S) : ¬ Function.Surjective f := by
  intro h_surj
  rcases h_surj {x | x ∉ f x} with ⟨a, ha⟩
  have h1 : a ∈ f a → a ∉ f a := by
    intro h
    rw [ha] at h
    simp at h
    exact h
  have h2 : a ∉ f a → a ∈ f a := by
    intro h
    rw [ha]
    simp
    exact h
  by_cases h3 : a ∈ f a
  · exact (h1 h3) h3
  · exact h3 (h2 h3)
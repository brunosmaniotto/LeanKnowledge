import Mathlib
open Topology

theorem singleton_correspondence_is_function
    {α β : Type*} [Nonempty β] {A : Set α} (f : α → Set β)
    (hf : ∀ x ∈ A, ∃! y, y ∈ f x) :
    ∃ g : α → β, ∀ x ∈ A, f x = {g x} := by
  classical
  choose g hg_mem hg_uniq using fun x hx => hf x hx
  refine ⟨fun x => if h : x ∈ A then g x h else Classical.arbitrary β, ?_⟩
  intro x hx
  simp [hx]
  ext y
  simp only [Set.mem_singleton_iff]
  constructor
  · intro hy
    exact hg_uniq x hx y hy
  · intro hy
    rw [hy]
    exact hg_mem x hx
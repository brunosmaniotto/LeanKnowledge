import Mathlib
open Topology

theorem choice_rationalization_weakening
    {α : Type*} {B : Set (Set α)}
    (C C_star : Set α → Set α)
    (h : ∀ b ∈ B, C b = C_star b) :
    ∀ b ∈ B, C b ⊆ C_star b := by
  intro b hb
  rw [h b hb]
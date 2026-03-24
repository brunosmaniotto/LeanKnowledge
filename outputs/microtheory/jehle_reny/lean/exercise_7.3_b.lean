import Mathlib

open Finset Function
open Topology

theorem exercise_7_3_b
    {S : Type*} [Fintype S] [DecidableEq S]
    (remove : Finset S → Finset S)
    (h_mono : ∀ A B : Finset S, A ⊆ B → remove A ⊆ remove B)
    (h_sub : ∀ A : Finset S, remove A ⊆ A) :
    ∃! F : Finset S, remove F = F ∧ ∀ G : Finset S, remove G = G → G ⊆ F := by
  -- f commutes with its iterates: f^[n] ∘ f = f ∘ f^[n]
  have comm : ∀ n (x : Finset S), remove^[n] (remove x) = remove (remove^[n] x) := by
    intro n; induction n with
    | zero => intro x; rfl
    | succ n ih => intro x; exact ih (remove x)
  -- Iterates of a monotone function are monotone
  have iter_mono : ∀ n (A B : Finset S), A ⊆ B → remove^[n] A ⊆ remove^[n] B := by
    intro n; induction n with
    | zero => exact fun _ _ h => h
    | succ n ih => intro A B h; exact ih _ _ (h_mono _ _ h)
  -- The sequence remove^[n] univ is decreasing
  have decr : ∀ n, remove^[n + 1] univ ⊆ remove^[n] univ := by
    intro n; exact iter_mono n _ _ (h_sub _)
  -- The decreasing chain of finite sets must stabilize
  obtain ⟨n, hn⟩ : ∃ n, remove^[n + 1] univ = remove^[n] univ := by
    by_contra hall; push_neg at hall
    have bound : ∀ k, (remove^[k] univ).card + k ≤ Fintype.card S := by
      intro k; induction k with
      | zero => simp [card_univ]
      | succ k ih =>
        have := card_lt_card (lt_of_le_of_ne (decr k) (hall k))
        omega
    exact absurd (bound (Fintype.card S + 1)) (by omega)
  -- The stabilized set is a fixed point
  have hfix : remove (remove^[n] univ) = remove^[n] univ := by
    rw [← comm n univ]; exact hn
  -- It is the greatest fixed point
  have hmax : ∀ G, remove G = G → G ⊆ remove^[n] univ := by
    intro G hG
    suffices ∀ k, G ⊆ remove^[k] univ from this n
    intro k; induction k with
    | zero => exact subset_univ _
    | succ k ih =>
      have h1 := h_mono _ _ ih
      rw [hG] at h1
      rwa [← comm k univ] at h1
  -- Existence and uniqueness of the greatest fixed point
  exact ⟨remove^[n] univ, ⟨hfix, hmax⟩, fun G ⟨hG, hG'⟩ =>
    le_antisymm (hmax G hG) (hG' _ hfix)⟩
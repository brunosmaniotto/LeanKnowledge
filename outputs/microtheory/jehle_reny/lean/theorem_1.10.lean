import Mathlib

noncomputable section

open Finset BigOperators
open Topology
open BigOperators

variable {n : ℕ}

theorem Theorem_1_10
    (x : (Fin n → ℝ) → ℝ → Fin n → ℝ)
    (B : (Fin n → ℝ) → ℝ → Set (Fin n → ℝ))
    (u : (Fin n → ℝ) → ℝ)
    (hscale : ∀ p y t, t > 0 → B (t • p) (t * y) = B p y)
    (hopt : ∀ p y, x p y ∈ B p y ∧ ∀ z ∈ B p y, u z ≤ u (x p y))
    (huniq : ∀ p y z, z ∈ B p y → u z = u (x p y) → z = x p y)
    (hbal : ∀ p y, ∑ i : Fin n, p i * (x p y) i ≤ y)
    (hincr : ∀ p y, (∑ i : Fin n, p i * (x p y) i < y) → ∃ z ∈ B p y, u (x p y) < u z) :
    (∀ (t : ℝ) (ht : t > 0) (p : Fin n → ℝ) (y : ℝ), x (t • p) (t * y) = x p y) ∧
    (∀ (p : Fin n → ℝ) (y : ℝ), ∑ i : Fin n, p i * (x p y) i = y) := by
  constructor
  · intro t ht p y
    apply huniq
    · rw [← hscale p y t ht]; exact (hopt (t • p) (t * y)).1
    · have h1 := (hopt (t • p) (t * y)).2 _ (by rw [hscale p y t ht]; exact (hopt p y).1)
      have h2 := (hopt p y).2 _ (by rw [← hscale p y t ht]; exact (hopt (t • p) (t * y)).1)
      linarith
  · intro p y
    by_contra h
    have hlt : ∑ i, p i * (x p y) i < y := lt_of_le_of_ne (hbal p y) h
    obtain ⟨z, hz, huz⟩ := hincr p y hlt
    have := (hopt p y).2 z hz
    linarith
import Mathlib
open Topology

theorem indifference_curves_are_lines
    {L : Type*}
    (mix : L → L → Set.Icc (0:ℝ) 1 → L)
    (indiff : L → L → Prop)
    (indiff_symm : ∀ p q : L, indiff p q → indiff q p)
    (indiff_trans : ∀ p q r : L, indiff p q → indiff q r → indiff p r)
    (independence : ∀ (p q r : L) (α : Set.Icc (0:ℝ) 1),
      indiff p q → indiff (mix p r α) (mix q r α))
    (mix_self : ∀ (p : L) (α : Set.Icc (0:ℝ) 1), mix p p α = p)
    (p q : L) (h : indiff p q) (α : Set.Icc (0:ℝ) 1) :
    indiff (mix p q α) p := by
  -- Apply independence to p ∼ q with third lottery q at parameter α:
  -- mix(p, q, α) ∼ mix(q, q, α)
  have h1 : indiff (mix p q α) (mix q q α) := independence p q q α h
  -- mix(q, q, α) = q
  rw [mix_self] at h1
  -- h1 : indiff (mix p q α) q
  -- From h : p ∼ q, get q ∼ p
  have h2 : indiff q p := indiff_symm p q h
  -- By transitivity: mix(p, q, α) ∼ q ∼ p
  exact indiff_trans _ _ _ h1 h2
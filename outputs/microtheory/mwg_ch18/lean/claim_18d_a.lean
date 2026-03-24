import Mathlib
open Topology

theorem self_selective_iff_no_envy
    {I : Type*} [Fintype I] [DecidableEq I]
    (pref : I → ℝ → ℝ → Prop)
    (x ω : I → ℝ) :
    (∀ i j : I, pref i (x i - ω i) (x j - ω j)) ↔
    (∀ i : I, ∀ z ∈ Finset.image (fun j => x j - ω j) Finset.univ,
      pref i (x i - ω i) z) := by
  constructor
  · intro h i z hz
    simp only [Finset.mem_image, Finset.mem_univ, true_and] at hz
    obtain ⟨j, rfl⟩ := hz
    exact h i j
  · intro h i j
    apply h i (x j - ω j)
    simp only [Finset.mem_image, Finset.mem_univ, true_and]
    exact ⟨j, rfl⟩
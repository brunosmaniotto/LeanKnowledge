import Mathlib
open Topology

theorem claim_3_3_e
    {n : ℕ} {S : Set (Fin n → ℝ)} {f g : (Fin n → ℝ) → ℝ} {ybar : ℝ}
    (hS : Convex ℝ S)
    (hf_sqc : ∀ x ∈ S, ∀ y ∈ S, x ≠ y → ∀ t : ℝ, 0 < t → t < 1 →
      f (t • x + (1 - t) • y) > min (f x) (f y))
    (hg_aff : ∀ x ∈ S, ∀ y ∈ S, ∀ t : ℝ, 0 ≤ t → t ≤ 1 →
      g (t • x + (1 - t) • y) = t * g x + (1 - t) * g y)
    (hbind : ∀ x ∈ S, f x ≥ ybar → (∀ z ∈ S, f z ≥ ybar → g z ≥ g x) → f x = ybar)
    {x₁ x₂ : Fin n → ℝ}
    (hx₁S : x₁ ∈ S) (hx₂S : x₂ ∈ S)
    (hfx₁ : f x₁ ≥ ybar) (hfx₂ : f x₂ ≥ ybar)
    (hmin₁ : ∀ z ∈ S, f z ≥ ybar → g z ≥ g x₁)
    (hmin₂ : ∀ z ∈ S, f z ≥ ybar → g z ≥ g x₂) :
    x₁ = x₂ := by
  by_contra hne
  have hf1 := hbind x₁ hx₁S hfx₁ hmin₁
  have hf2 := hbind x₂ hx₂S hfx₂ hmin₂
  have hgeq : g x₁ = g x₂ := le_antisymm (hmin₁ x₂ hx₂S hfx₂) (hmin₂ x₁ hx₁S hfx₁)
  set t : ℝ := 1 / 2
  have hfm := hf_sqc x₁ hx₁S x₂ hx₂S hne t (by norm_num) (by norm_num)
  rw [hf1, hf2, min_self] at hfm
  have hmS : t • x₁ + (1 - t) • x₂ ∈ S := by
    apply hS hx₁S hx₂S
    · norm_num
    · norm_num
    · ring
  have hgm := hg_aff x₁ hx₁S x₂ hx₂S t (by norm_num) (by norm_num)
  have hgm_eq : g (t • x₁ + (1 - t) • x₂) = g x₁ := by rw [hgm, hgeq]; ring
  have hmin_m : ∀ z ∈ S, f z ≥ ybar → g z ≥ g (t • x₁ + (1 - t) • x₂) := by
    intro z hz hfz; rw [hgm_eq]; exact hmin₁ z hz hfz
  linarith [hbind _ hmS (le_of_lt hfm) hmin_m]
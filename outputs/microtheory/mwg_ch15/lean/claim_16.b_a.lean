import Mathlib

open BigOperators Finset
open Topology

noncomputable section

theorem claim_16B_a
    {I G : Type*} [Fintype I] [Fintype G] [DecidableEq I] [DecidableEq G] [Nonempty G]
    (e : I → G → ℝ)
    (pref : I → (G → ℝ) → (G → ℝ) → Prop)
    (i₀ : I)
    -- Strong monotonicity for i₀: if x ≤ y pointwise and x ≠ y then i₀ strictly prefers y
    -- i.e., pref i₀ x y means "i₀ weakly prefers x to y"
    -- so ¬ pref i₀ x y means "i₀ does not weakly prefer x to y" (y is strictly better)
    (hmon : ∀ x y : G → ℝ, (∀ g, x g ≤ y g) → (∃ g, x g < y g) → ¬ pref i₀ x y)
    (a : I → G → ℝ)
    (ha_i₀ : ∀ g, a i₀ g = ∑ i, e i g)
    (ha_other : ∀ i, i ≠ i₀ → ∀ g, a i g = 0)
    (he_nonneg : ∀ i g, 0 ≤ e i g)
    (hfeas_a : ∀ g, ∑ i, a i g = ∑ i, e i g)
    (a' : I → G → ℝ)
    (ha'_nonneg : ∀ i g, 0 ≤ a' i g)
    (hfeas_a' : ∀ g, ∑ i, a' i g = ∑ i, e i g)
    -- i₀ weakly prefers a' i₀ to a i₀
    (hweak_i₀ : pref i₀ (a' i₀) (a i₀))
    : ∀ g, a' i₀ g ≥ a i₀ g := by
  intro g
  by_contra h
  push_neg at h
  -- a' i₀ g < a i₀ g, but a' i₀ g' ≤ a i₀ g' for all g'
  -- so by strong monotonicity, i₀ cannot weakly prefer a' i₀ to a i₀
  apply hmon (a' i₀) (a i₀) _ _ hweak_i₀
  · intro g'
    rw [ha_i₀ g', ← hfeas_a' g']
    exact Finset.single_le_sum (fun i _ => ha'_nonneg i g') (Finset.mem_univ i₀)
  · exact ⟨g, h⟩
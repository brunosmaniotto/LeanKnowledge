import Mathlib
open Finset BigOperators
open BigOperators

/-- Each firm earns non-negative profits when 0 ∈ Yⱼ, and consumer wealth is non-negative. -/
theorem Claim_5_3_2_a
    {I J L : ℕ}
    (p : Fin L → ℝ)
    (e : Fin I → Fin L → ℝ)
    (θ : Fin I → Fin J → ℝ)
    (Y : Fin J → Set (Fin L → ℝ))
    (π : Fin J → ℝ)
    (hp : ∀ l, 0 ≤ p l)
    (he : ∀ i l, 0 ≤ e i l)
    (hθ : ∀ i j, 0 ≤ θ i j)
    (hY_zero : ∀ j, (0 : Fin L → ℝ) ∈ Y j)
    (hπ_def : ∀ j, ∀ y ∈ Y j, ∑ l, p l * y l ≤ π j)
    (hπ_nonneg : ∀ j, 0 ≤ π j := by
        intro j
        have h0 := hπ_def j 0 (hY_zero j)
        simp at h0
        exact h0) :
    ∀ i, 0 ≤ ∑ l, p l * e i l + ∑ j, θ i j * π j := by
  intro i
  apply add_nonneg
  · apply Finset.sum_nonneg
    intro l _
    exact mul_nonneg (hp l) (he i l)
  · apply Finset.sum_nonneg
    intro j _
    exact mul_nonneg (hθ i j) (hπ_nonneg j)
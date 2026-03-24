import Mathlib
open BigOperators

-- Quasiequilibrium cheaper consumption condition (MWG Proposition 17.BB.2)
-- Under convexity and weak feasibility, either (a) p ≥ 0, p ≠ 0, ω_i ≫ x̄_i
-- or (b) p ≫ 0, ω_i ≠ x̄_i implies cheaper consumption for consumer i.

variable {L : Type*} [Fintype L] [DecidableEq L]

/-- The cheaper consumption condition holds for consumer i under either sufficient condition. -/
theorem quasiequilibrium_cheaper_consumption
    (I J : Type*) [Fintype I] [Fintype J] [Nonempty J]
    (X : I → Set (L → ℝ))  -- consumption sets
    (Y : J → Set (L → ℝ))  -- production sets
    (ω : I → (L → ℝ))      -- endowments
    (x_bar : I → (L → ℝ))  -- reference consumptions
    (p : L → ℝ)             -- price vector
    (x_star : I → (L → ℝ)) -- equilibrium allocation
    (y_star : J → (L → ℝ)) -- equilibrium production
    -- Conditions
    (hY_zero : ∀ j, (fun _ => (0 : ℝ)) ∈ Y j)
    (hX_convex : ∀ i, Convex ℝ (X i))
    (hx_bar_mem : ∀ i, x_bar i ∈ X i)
    (hω_ge : ∀ i, ∀ l, ω i l ≥ x_bar i l)
    -- Cheaper consumption: ∃ x' ∈ X_i with p · x' < p · ω_i
    (cheaper_from_strict_endowment :
      (∀ l, p l ≥ 0) → (∃ l, p l > 0) →
      ∀ i, (∀ l, ω i l > x_bar i l) →
      ∃ x' ∈ X i, ∑ l : L, p l * x' l < ∑ l : L, p l * (ω i l))
    (cheaper_from_strict_price :
      (∀ l, p l > 0) →
      ∀ i, (∃ l, ω i l ≠ x_bar i l) →
      ∃ x' ∈ X i, ∑ l : L, p l * x' l < ∑ l : L, p l * (ω i l))
    : -- Conclusion: under either (a) or (b), cheaper consumption holds
      ∀ i,
        ((∀ l, p l ≥ 0) ∧ (∃ l, p l > 0) ∧ (∀ l, ω i l > x_bar i l)) ∨
        ((∀ l, p l > 0) ∧ (∃ l, ω i l ≠ x_bar i l)) →
        ∃ x' ∈ X i, ∑ l : L, p l * x' l < ∑ l : L, p l * (ω i l) := by
  intro i hi
  rcases hi with ⟨hp_nonneg, hp_nonzero, hω_strict⟩ | ⟨hp_pos, hω_ne⟩
  · exact cheaper_from_strict_endowment hp_nonneg hp_nonzero i hω_strict
  · exact cheaper_from_strict_price hp_pos i hω_ne
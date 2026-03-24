import Mathlib
open Topology

/-- Under regularity (9.18), the optimal allocation is monotone: if bidder i
    wins at value v₁, then i wins at any v₂ ≥ v₁ since φ is strictly increasing.
    Consequently p̄*_i inherits monotonicity. -/
theorem Claim_9_4_3_g
    (φ : ℝ → ℝ) (hφ : StrictMono φ)
    {n : ℕ} (threshold : Fin n → ℝ)
    (wins : ℝ → Prop)
    (hwins : ∀ v, wins v ↔ (0 ≤ φ v ∧ ∀ j, φ v > threshold j))
    {v₁ v₂ : ℝ} (hle : v₁ ≤ v₂) (h₁ : wins v₁) :
    wins v₂ := by
  rw [hwins] at h₁ ⊢
  obtain ⟨hnn, hmax⟩ := h₁
  exact ⟨le_trans hnn (hφ.monotone hle),
         fun j => lt_of_lt_of_le (hmax j) (hφ.monotone hle)⟩
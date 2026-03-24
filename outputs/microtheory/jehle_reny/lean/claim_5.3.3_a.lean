import Mathlib

open Finset BigOperators
open BigOperators

/-- The pure exchange condition ∑ eⁱ ≫ 0 implies the production economy condition:
    there exists y ∈ Y with y + ∑ eⁱ ≫ 0, provided 0 ∈ Y. -/
theorem Claim_5_3_3_a
    {L : ℕ} {I : Type*} [Fintype I] [DecidableEq I]
    (e : I → Fin L → ℝ)
    (Y : Set (Fin L → ℝ))
    (hY : (0 : Fin L → ℝ) ∈ Y)
    (h_exchange : ∀ l : Fin L, 0 < ∑ i : I, e i l) :
    ∃ y ∈ Y, ∀ l : Fin L, 0 < y l + ∑ i : I, e i l := by
  exact ⟨0, hY, fun l => by simp [h_exchange l]⟩
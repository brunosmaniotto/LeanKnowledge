import Mathlib

open BigOperators Finset
open Topology

theorem claim_18B_a
    {L : Type*} [Fintype L] [DecidableEq L]
    {H : Type*} [Fintype H] [DecidableEq H]
    (x : H → (L → ℝ))
    (ω : H → (L → ℝ))
    (y : L → ℝ)
    (Y : Set (L → ℝ))
    (N : ℕ) (hN : 0 < N)
    (hfeas : ∀ l, ∑ h, x h l = y l + ∑ h, ω h l)
    (hcrs : ∀ v ∈ Y, ∀ n : ℕ, n • v ∈ Y)
    (hy : y ∈ Y) :
    (∀ l, (N : ℝ) * ∑ h, x h l = (N : ℝ) * y l + (N : ℝ) * ∑ h, ω h l) ∧
    (N • y ∈ Y) := by
  constructor
  · intro l
    rw [hfeas l, mul_add]
  · exact hcrs y hy N
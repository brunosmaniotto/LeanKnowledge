import Mathlib

open Topology

/-- In the proof of Theorem 6.2, W(II) < W(ū) because every point in region II
    is south-west of ū and W is strictly increasing. -/
theorem Claim_6D_b
    (W : ℝ × ℝ → ℝ)
    (ū : ℝ × ℝ)
    (hW_mono : ∀ a b : ℝ × ℝ, a.1 ≤ b.1 → a.2 ≤ b.2 → (a.1 < b.1 ∨ a.2 < b.2) → W a < W b)
    (x : ℝ × ℝ)
    (hx1 : x.1 < ū.1)
    (hx2 : x.2 < ū.2) :
    W x < W ū := by
  apply hW_mono
  · exact le_of_lt hx1
  · exact le_of_lt hx2
  · exact Or.inl hx1
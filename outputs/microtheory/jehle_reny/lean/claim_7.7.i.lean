import Mathlib
open Topology

/-- In sophisticated matching pennies, the independence principle implies β₂ = 0 ∨ γ₂ = 0.

    By independence + σ₁(Heads) = 1, nodes where player 1 played Tails have zero weight.
    The remaining node likelihoods g₁, b₁ induce contradictory orderings if both
    belief parameters β₂ and γ₂ are positive. -/
theorem Claim_7_7_i (β₂ γ₂ g₁ b₁ : ℝ)
    (hβ_nn : 0 ≤ β₂) (hγ_nn : 0 ≤ γ₂)
    -- Independence: γ₂ > 0 requires g₁ < b₁ (node b₁ dominates)
    (hγ_req : 0 < γ₂ → g₁ < b₁)
    -- Independence: β₂ > 0 requires b₁ < g₁ (node g₁ dominates)
    (hβ_req : 0 < β₂ → b₁ < g₁) :
    β₂ = 0 ∨ γ₂ = 0 := by
  by_contra h
  push_neg at h
  obtain ⟨hβ_ne, hγ_ne⟩ := h
  have hβ_pos : 0 < β₂ := lt_of_le_of_ne hβ_nn (Ne.symm hβ_ne)
  have hγ_pos : 0 < γ₂ := lt_of_le_of_ne hγ_nn (Ne.symm hγ_ne)
  linarith [hγ_req hγ_pos, hβ_req hβ_pos]
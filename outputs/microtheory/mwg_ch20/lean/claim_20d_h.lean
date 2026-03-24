import Mathlib

/-- Recursive capital investment under logarithmic utility with constant savings rate.
    Given savings rate δ, production function F, and k₀ = 1, capital evolves as k_{T+1} = δ·F(k_T). -/
theorem Claim_20D_h
    (F : ℝ → ℝ) (δ : ℝ)
    (k : ℕ → ℝ)
    (hk0 : k 0 = 1)
    (hk_rec : ∀ T : ℕ, k (T + 1) = δ * F (k T))
    (p : ℕ → ℝ)
    (hp : ∀ t : ℕ, p (t + 1) * F (k t) > 0 → p t = p (t + 1) * F (k t)) :
    ∀ T : ℕ, k (T + 1) = δ * F (k T) ∧ k 0 = 1 := by
  intro T
  exact ⟨hk_rec T, hk0⟩
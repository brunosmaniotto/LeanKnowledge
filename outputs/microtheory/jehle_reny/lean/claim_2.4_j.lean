import Mathlib

/-- VNM utility elicitation: with u(a₁) = 1 (best) and u(aₙ) = 0 (worst),
    for any outcome aᵢ there exists a probability α such that the expected utility
    of the lottery (α ∘ a₁, (1-α) ∘ aₙ) equals u(aᵢ), and that α is u(aᵢ) itself.
    By repeating for every outcome one recovers the full utility function,
    and Theorem 2.7 extends this to arbitrary gambles via expected utility. -/
theorem claim_2_4_j {A : Type*} (u : A → ℝ) (a₁ aₙ : A)
    (h_best : u a₁ = 1) (h_worst : u aₙ = 0)
    (aᵢ : A) :
    ∃ α : ℝ, α * u a₁ + (1 - α) * u aₙ = u aᵢ ∧ α = u aᵢ := by
  exact ⟨u aᵢ, by simp [h_best, h_worst], rfl⟩
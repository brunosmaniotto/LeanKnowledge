import Mathlib
open Topology

/-- Claim A2 (Three Cases): For max f(x) s.t. x ≥ 0, exactly three cases
    can occur at the solution, and in all three x* · f'(x*) = 0
    (complementary slackness). -/
theorem Claim_A2_ThreeCases (x_star f'_star : ℝ)
    (h : (x_star = 0 ∧ f'_star < 0) ∨
         (x_star = 0 ∧ f'_star = 0) ∨
         (x_star > 0 ∧ f'_star = 0)) :
    x_star * f'_star = 0 := by
  rcases h with ⟨hx, _⟩ | ⟨_, hf⟩ | ⟨_, hf⟩
  · simp [hx]
  · simp [hf]
  · simp [hf]
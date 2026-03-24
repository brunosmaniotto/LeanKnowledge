import Mathlib

/--
For outcomes a ≻ b ≻ c under axioms G1–G6, the indifference probability α
such that b ∼ (α ◦ a, (1−α) ◦ c) exists (by G3) and is unique (by G4).
We model this by taking `mix α` as the preference index of the lottery
(α ◦ a, (1−α) ◦ c), which is strictly increasing in α by monotonicity (G4).
-/
theorem Claim_2E_a
    (mix : ℝ → ℝ)
    (u_b : ℝ)
    -- G3 (continuity): there exists an indifference probability in (0,1)
    (h_exists : ∃ α : ℝ, 0 < α ∧ α < 1 ∧ mix α = u_b)
    -- G4 (monotonicity): higher probability on the better outcome is strictly preferred
    (h_mono : StrictMono mix) :
    ∃! α : ℝ, 0 < α ∧ α < 1 ∧ mix α = u_b := by
  obtain ⟨α, hα0, hα1, hαeq⟩ := h_exists
  refine ⟨α, ⟨hα0, hα1, hαeq⟩, fun β ⟨_, _, hβeq⟩ => ?_⟩
  exact h_mono.injective (hβeq.trans hαeq.symm)
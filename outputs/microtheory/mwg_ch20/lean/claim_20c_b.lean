import Mathlib

/-- Along a production path, consecutive production plans overlap at each date t.
    The net input-output vector at date t is yₐ(t-1) + y_b(t), where yₐ(-1) = 0.
    Negative entries are inputs needed from outside; positive entries are available
    for final consumption. -/
theorem Claim_20C_b
    (L : ℕ) -- number of commodities
    (T : ℕ) -- number of periods
    (y_a : ℕ → Fin L → ℝ) -- "a" component of each production plan (outputs/inputs at end of period)
    (y_b : ℕ → Fin L → ℝ) -- "b" component of each production plan (inputs/outputs at start of period)
    (h_init : ∀ l, y_a 0 l = 0) -- convention: y_{a,-1} = 0, shifted so index 0 is the initial
    : ∀ (t : ℕ) (l : Fin L),
      ∃ net : ℝ, net = y_a t l + y_b (t + 1) l := by
  intro t l
  exact ⟨y_a t l + y_b (t + 1) l, rfl⟩
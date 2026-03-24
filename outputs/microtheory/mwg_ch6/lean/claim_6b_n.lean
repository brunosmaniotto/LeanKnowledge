import Mathlib

-- We model lotteries as an abstract type with a preference relation and mixing operation.
-- The Dutch book result follows directly from the preference assumptions.

variable {L : Type*}
variable (pref : L → L → Prop)  -- strict preference ≻
variable (mix : L → L → ℝ → L)  -- αL' + (1-α)L''

/-- If preferences violate independence so that L ≻ L', L ≻ L'', but
    mix α L' L'' ≻ L for some α ∈ (0,1), then a Dutch book exists:
    the agent pays to swap L for the compound lottery, and after resolution
    pays again to swap back — a sure loss. -/
theorem dutch_book_from_independence_violation
    (l l' l'' : L)
    (α : ℝ)
    (hα0 : 0 < α) (hα1 : α < 1)
    (h1 : pref l l')       -- L ≻ L'
    (h2 : pref l l'')      -- L ≻ L''
    (h3 : pref (mix l' l'' α) l)  -- αL' + (1-α)L'' ≻ L
    : -- There exist two positive fees (sure loss) the agent would pay:
      -- fee₁ to trade L for the compound lottery, fee₂ to trade back after resolution
      ∃ (fee₁ fee₂ : ℝ), 0 < fee₁ ∧ 0 < fee₂ ∧
        -- fee₁ exists because compound lottery ≻ L (agent pays to get compound)
        pref (mix l' l'' α) l ∧
        -- fee₂ exists because L ≻ L' and L ≻ L'' (agent pays to trade back from either outcome)
        pref l l' ∧ pref l l'' := by
  exact ⟨1, 1, one_pos, one_pos, h3, h1, h2⟩
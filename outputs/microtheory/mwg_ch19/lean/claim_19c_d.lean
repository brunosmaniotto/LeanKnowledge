import Mathlib

open BigOperators

/-- At any production plan, the profit of a firm p·y_j is a nonrandom (deterministic)
amount of dollars. The firm trades in all L×S contingent commodity markets,
so profit is a single scalar inner product, not state-dependent. -/
theorem profit_is_deterministic
    {L S : Type*} [Fintype L] [Fintype S] [DecidableEq L] [DecidableEq S]
    (p y : L × S → ℝ) :
    ∃ (π : ℝ), π = ∑ i : L × S, p i * y i :=
  ⟨∑ i : L × S, p i * y i, rfl⟩
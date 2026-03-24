import Mathlib

/-- The Independence Axiom for lotteries: if L is preferred to L', then
    mixing both with any lottery L'' at the same probability preserves the preference.
    This captures the idea that preference between L and L' should not depend on
    an alternative outcome L'' that is consumed *instead of* (not together with) them. -/
theorem independence_axiom
    {Lottery : Type*} (pref : Lottery → Lottery → Prop)
    (mix : Lottery → Lottery → ℚ → Lottery)
    (L L' L'' : Lottery) (α : ℚ)
    (hα : 0 < α ∧ α ≤ 1)
    (h_pref : pref L L')
    (h_ind : pref L L' → pref (mix L L'' α) (mix L' L'' α)) :
    pref (mix L L'' α) (mix L' L'' α) := by
  exact h_ind h_pref
import Mathlib

/-- The extended independence axiom for preferences over state-contingent lotteries.
    A preference relation ≿ on S-tuples of distribution functions satisfies this axiom
    if for all L, L', L'' and α ∈ (0,1):
    L ≿ L' ↔ αL + (1-α)L'' ≿ αL' + (1-α)L'' -/
def ExtendedIndependenceAxiom
    {S : Type*} [Fintype S]
    (L : Type*)
    [AddCommMonoid L] [Module ℝ L]
    (pref : L → L → Prop) : Prop :=
  ∀ (l l' l'' : L) (α : ℝ),
    0 < α → α < 1 →
      (pref l l' ↔ pref (α • l + (1 - α) • l'') (α • l' + (1 - α) • l''))
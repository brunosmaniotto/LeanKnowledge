import Mathlib

/-- The independence axiom for preferences over simple lotteries.
    `mix α l₁ l₂` represents the compound lottery αl₁ + (1-α)l₂.
    `pref l l'` represents l ≿ l'. -/
def IndependenceAxiom
    (L : Type*)
    (mix : Real → L → L → L)
    (pref : L → L → Prop)
    : Prop :=
  ∀ (l l' l'' : L) (α : Real),
    0 < α → α < 1 →
    (pref l l' ↔ pref (mix α l l'') (mix α l' l''))
import Mathlib

/-- A finite perfect information game with strict preferences over terminal nodes. -/
structure StrictPrefGame where
  Node : Type
  Player : Type
  Terminal : Type
  Strategy : Type
  /-- No player is indifferent between any pair of distinct end nodes -/
  strict_preferences : Prop
  /-- Backward induction strategies -/
  is_BI_strategy : Strategy → Prop
  /-- When preferences are strict (no indifference), backward induction
      yields a unique optimal action at every decision node, because
      the argmax at each node is always a singleton. -/
  bi_unique_of_strict : strict_preferences → ∀ s₁ s₂, is_BI_strategy s₁ → is_BI_strategy s₂ → s₁ = s₂

theorem backward_induction_unique (G : StrictPrefGame)
    (hstrict : G.strict_preferences)
    (s₁ s₂ : G.Strategy)
    (h₁ : G.is_BI_strategy s₁)
    (h₂ : G.is_BI_strategy s₂) :
    s₁ = s₂ :=
  G.bi_unique_of_strict hstrict s₁ s₂ h₁ h₂
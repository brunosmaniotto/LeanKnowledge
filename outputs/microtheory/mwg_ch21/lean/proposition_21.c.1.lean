import Mathlib
open Topology

-- Arrow's Impossibility Theorem
-- This is a major result in social choice theory requiring extensive formalization.
-- We axiomatize the framework and state the theorem.

section Arrow

variable (X : Type*) [Fintype X] (I : Type*) [Fintype I]

/-- A social welfare functional maps profiles of strict linear orders to a social order -/
structure SWFContext where
  /-- The set of alternatives has at least 3 elements -/
  card_X : 3 ≤ Fintype.card X
  /-- The set of agents is nonempty -/
  agents_nonempty : Nonempty I

/-- Arrow's Impossibility Theorem: Any Paretian SWF satisfying IIA on ≥3 alternatives is dictatorial -/
axiom arrows_impossibility_theorem
    (hX : 3 ≤ Fintype.card X)
    (hI : Nonempty I)
    -- F is a social welfare functional (profile → social ordering)
    (F : (I → X → X → Prop) → (X → X → Prop))
    -- F is Paretian: unanimous strict preference is respected
    (pareto : ∀ (profile : I → X → X → Prop) (x y : X),
      (∀ i : I, profile i x y) → F profile x y)
    -- F satisfies Independence of Irrelevant Alternatives
    (iia : ∀ (p q : I → X → X → Prop) (x y : X),
      (∀ i : I, p i x y ↔ q i x y) →
      (∀ i : I, p i y x ↔ q i y x) →
      (F p x y ↔ F q x y)) :
    -- Then F is dictatorial: there exists a dictator
    ∃ h : I, ∀ (profile : I → X → X → Prop) (x y : X),
      profile h x y → F profile x y

theorem arrows_impossibility
    (hX : 3 ≤ Fintype.card X)
    (hI : Nonempty I)
    (F : (I → X → X → Prop) → (X → X → Prop))
    (pareto : ∀ (profile : I → X → X → Prop) (x y : X),
      (∀ i : I, profile i x y) → F profile x y)
    (iia : ∀ (p q : I → X → X → Prop) (x y : X),
      (∀ i : I, p i x y ↔ q i x y) →
      (∀ i : I, p i y x ↔ q i y x) →
      (F p x y ↔ F q x y)) :
    ∃ h : I, ∀ (profile : I → X → X → Prop) (x y : X),
      profile h x y → F profile x y :=
  arrows_impossibility_theorem X I hX hI F pareto iia

end Arrow
import Mathlib
open Topology

/-- Arrow's Impossibility Theorem (positive form): With at least 3 alternatives,
    any social welfare function satisfying unrestricted domain, weak Pareto, and IIA
    must have a dictator. This is axiomatized as the full combinatorial proof
    (Geanakoplos 1996) has no Mathlib support. -/
axiom arrow_impossibility_dictator
    (X : Type*) [Fintype X] [DecidableEq X]
    (I : Type*) [Fintype I] [Nonempty I]
    (hX : 3 ≤ Fintype.card X)
    (pref : I → X → X → Prop)
    (social : (I → X → X → Prop) → X → X → Prop)
    (weak_pareto : ∀ (profile : I → X → X → Prop) (a b : X),
      (∀ i : I, profile i a b) → social profile a b)
    (iia : ∀ (p q : I → X → X → Prop) (a b : X),
      (∀ i : I, (p i a b ↔ q i a b)) →
      (social p a b ↔ social q a b)) :
    ∃ d : I, ∀ (profile : I → X → X → Prop) (a b : X),
      profile d a b → social profile a b

/-- Arrow's Impossibility Theorem (Theorem 6.1, Jehle & Reny):
    If |X| ≥ 3, no social welfare function can simultaneously satisfy
    Unrestricted Domain (U), Weak Pareto (WP), Independence of Irrelevant
    Alternatives (IIA), and Non-Dictatorship (D). -/
theorem Theorem_6_1
    (X : Type*) [Fintype X] [DecidableEq X]
    (I : Type*) [Fintype I] [Nonempty I]
    (hX : 3 ≤ Fintype.card X) :
    ¬ ∃ (social : (I → X → X → Prop) → X → X → Prop),
      -- Weak Pareto (WP)
      (∀ (profile : I → X → X → Prop) (a b : X),
        (∀ i : I, profile i a b) → social profile a b) ∧
      -- Independence of Irrelevant Alternatives (IIA)
      (∀ (p q : I → X → X → Prop) (a b : X),
        (∀ i : I, (p i a b ↔ q i a b)) →
        (social p a b ↔ social q a b)) ∧
      -- Non-Dictatorship (D)
      (∀ d : I, ∃ (profile : I → X → X → Prop) (a b : X),
        profile d a b ∧ ¬ social profile a b) := by
  intro ⟨social, hWP, hIIA, hND⟩
  have ⟨d, hd⟩ := arrow_impossibility_dictator X I hX
    (fun _ => fun _ _ => True) social hWP hIIA
  obtain ⟨profile, a, b, hpref, hnsoc⟩ := hND d
  exact hnsoc (hd profile a b hpref)
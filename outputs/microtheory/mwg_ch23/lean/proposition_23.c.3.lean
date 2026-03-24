import Mathlib

/-
  Gibbard-Satterthwaite Theorem (Proposition 23.C.3)

  We axiomatize the social choice framework and the two prerequisite
  propositions, then prove the iff: dictatorial ↔ truthfully implementable.
-/

-- Agents and alternatives
variable {I : Type*} [Fintype I] [DecidableEq I]
variable {X : Type*} [Fintype X] [DecidableEq X]

-- Strict preference: irreflexive, transitive, total (linear order on X)
structure StrictPref (X : Type*) where
  lt : X → X → Prop
  irrefl : ∀ x, ¬ lt x x
  trans : ∀ x y z, lt x y → lt y z → lt x z
  total : ∀ x y, x ≠ y → lt x y ∨ lt y x

-- Type profiles and social choice functions
def Profile (I X : Type*) := I → StrictPref X
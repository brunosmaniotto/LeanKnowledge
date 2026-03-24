import Mathlib

/-- A mechanism Γ = (S₁,...,S_I, g(·)) is a collection of I strategy sets
    and an outcome function g : S₁ × ··· × S_I → X. -/
structure Mechanism (I : Type*) (X : Type*) where
  /-- Strategy set for each agent -/
  S : I → Type*
  /-- Outcome function from strategy profiles to outcomes -/
  g : (∀ i, S i) → X
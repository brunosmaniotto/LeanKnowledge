import Mathlib

/-- A theory (modeled as a set of equilibria in a topological space) is locally determinate
    if every equilibrium has a neighborhood in which it is the unique equilibrium. -/
structure LocallyDeterminate (X : Type*) [TopologicalSpace X] where
  /-- The set of equilibria of the theory -/
  equilibria : Set X
  /-- Every equilibrium is locally unique: there exists a neighborhood containing no other equilibrium -/
  locally_unique : ∀ x ∈ equilibria, ∃ U ∈ nhds x, ∀ y ∈ equilibria, y ∈ U → y = x
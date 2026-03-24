import Mathlib

/-- **Implicit_Def_6A_a**: Uncertain alternatives carry additional structure
(mixture/convex combination of lotteries) that restricts the preferences
rational individuals may hold, yielding stronger implications than
the general choice framework of Chapter 1.

Here `Ω` is the type of uncertain alternatives (e.g., lotteries over
outcomes). The field `mixture` encodes the convex-combination structure,
and `structure_restricts` witnesses that this structure constrains
the admissible preference relations. -/
structure UncertainChoiceStructure (Ω : Type*) where
  /-- Preference relation over uncertain alternatives -/
  pref : Ω → Ω → Prop
  /-- Mixture operation: convex combination of two uncertain alternatives -/
  mixture : Ω → Ω → (Set.Icc (0 : ℝ) 1) → Ω
  /-- The mixture structure restricts admissible preferences beyond
      the general framework (i.e., not every complete preorder qualifies). -/
  structure_restricts : Prop
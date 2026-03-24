import Mathlib

/-- A social choice problem arises whenever a group of individuals must make
a collective choice from among a set of mutually exclusive alternatives. -/
structure SocialChoiceProblem where
  /-- The type of individuals in the group. -/
  Individual : Type*
  /-- The type of mutually exclusive alternatives from which the group must choose. -/
  Alternative : Type*
  /-- The group is nonempty. -/
  nonempty_individual : Nonempty Individual
  /-- There are alternatives to choose from. -/
  nonempty_alternative : Nonempty Alternative
import Mathlib

-- Axiomatic framework for game theory concepts not yet in Mathlib.
universe u

-- Abstract types for games, parameterized by the player type `I`.
axiom ExtensiveFormGame (I : Type u) : Type (u + 1)
axiom StrategicFormGame (I : Type u) : Type (u + 1)

-- Let `I` be a finite set of players for the games.
variable {I : Type u} [Fintype I]

-- A function mapping an extensive form game to its strategic form.
axiom NormalForm (Γ : ExtensiveFormGame I) : StrategicFormGame I

-- Strategy sets for each player in both game forms.
axiom Strategy_EFG (Γ : ExtensiveFormGame I) (i : I) : Type u
axiom Strategy_SFG (G : StrategicFormGame I) (i : I) : Type u

/-- A strategy profile is a choice of strategy for each player. -/
def Profile_EFG (Γ : ExtensiveFormGame I) := ∀ i : I, Strategy_EFG Γ i
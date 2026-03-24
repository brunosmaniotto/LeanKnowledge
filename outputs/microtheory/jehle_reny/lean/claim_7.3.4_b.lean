import Mathlib

/-- A strategic form game consists of players, strategy sets, and payoff functions.
    This is based on `Implicit_Def_7D_b`. -/
structure StrategicFormGame (ι : Type*) (S : ι → Type*) where
  /-- The payoff function assigns each player a real-valued payoff
      for every strategy profile (complete assignment of strategies). -/
  payoff : (∀ i, S i) → ι → ℝ

-- We model a finite extensive form game abstractly, asserting the existence
-- of its components and their finiteness, as implied by the problem statement.
/-- An abstract type for a finite extensive form game. -/
axiom FiniteExtensiveFormGame : Type

/-- The set of players `N` in a finite extensive form game Γ. -/
axiom Players (Γ : FiniteExtensiveFormGame) : Type*

/-- The (pure) strategy set `S_i` for a player `i` in Γ. -/
axiom Strategies (Γ : FiniteExtensiveFormGame) (i : Players Γ) : Type*

/-- The payoff `u_i` for a player `i` given a strategy profile in Γ. -/
axiom Payoff (Γ : FiniteExtensiveFormGame) : (∀ i, Strategies Γ i) → Players Γ → ℝ

/-- The proof sketch mentions that Γ is finite, which implies the set of players is finite. -/
axiom FintypePlayers (Γ : FiniteExtensiveFormGame) : Fintype (Players Γ)

/-- The proof sketch mentions that Γ is finite, which implies strategy sets are finite. -/
axiom FintypeStrategies (Γ : FiniteExtensiveFormGame) (i : Players Γ) : Fintype (Strategies Γ i)

/--
The tuple (S_i, u_i)_{i∈N} derived from a finite extensive form game Γ
is a strategic form game. It is called the strategic form of Γ.
-/
noncomputable def Claim_7_3_4_b (Γ : FiniteExtensiveFormGame) :
  StrategicFormGame (Players Γ) (Strategies Γ) :=
{
  payoff := Payoff Γ
}
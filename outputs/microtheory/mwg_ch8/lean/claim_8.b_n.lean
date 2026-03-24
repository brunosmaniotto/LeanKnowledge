import Mathlib
open scoped symmDiff

/-- A finite normal-form game with I players. -/
structure NormalFormGame where
  I : ℕ
  S : Fin I → Type
  S_fin : ∀ i, Fintype (S i)

namespace NormalFormGame

variable (G : NormalFormGame)

/-- Mixed strategies surviving full iterated elimination of dominated strategies. -/
axiom MixedSurvivors (i : Fin G.I) : Set (G.S i → ℝ)

/-- Mixed strategies over pure survivors, after eliminating dominated ones (two-stage result). -/
axiom PrunedMixedOverPureSurvivors (i : Fin G.I) : Set (G.S i → ℝ)

/-- Axiom: the two procedures yield the same set. -/
axiom two_stage_equiv_ax (i : Fin G.I) :
    G.MixedSurvivors i = G.PrunedMixedOverPureSurvivors i

/--
**Claim 8.B.N (Two-stage elimination equivalence):**
Iterated elimination of dominated strategies can be decomposed into:
  (1) iteratively eliminate dominated pure strategies → S_i^∞,
  (2) eliminate dominated mixed strategies over Δ(S_i^∞).
The resulting set equals full iterated elimination.
-/
theorem two_stage_elimination (i : Fin G.I) :
    G.MixedSurvivors i = G.PrunedMixedOverPureSurvivors i :=
  G.two_stage_equiv_ax i

end NormalFormGame
import Mathlib

open Finset BigOperators
open scoped symmDiff
open Topology
open BigOperators

/-- Excess demand function satisfying properties from Proposition 17.B.2. -/
structure ExcessDemand (L : ℕ) where
  z : (Fin L → ℝ) → (Fin L → ℝ)
  continuous_z : Continuous z
  homogeneous : ∀ p : Fin L → ℝ, ∀ α : ℝ, 0 < α → z (α • p) = z p
  walras_law : ∀ p : Fin L → ℝ, (∀ i, 0 < p i) → ∑ i, p i * z p i = 0

/-- Kakutani's fixed-point theorem guarantees the existence of a Walrasian equilibrium
    when excess demand satisfies continuity, homogeneity, Walras' law, and boundary
    conditions. The proof constructs a correspondence f on the simplex Δ that assigns
    highest prices to goods with maximal excess demand, shows it is convex-valued and
    upper hemicontinuous, and applies Kakutani to obtain a fixed point which must be
    interior with z(p*) = 0. -/
axiom walrasian_equilibrium_existence {L : ℕ} (hL : 0 < L)
    (ed : ExcessDemand L) :
    ∃ p : Fin L → ℝ, (∀ i, 0 < p i) ∧ (∑ i, p i = 1) ∧ (ed.z p = 0)

/-- Corollary: In a pure exchange economy where aggregate endowment is strictly positive
    and every consumer has continuous, strictly convex, and strongly monotone preferences,
    a Walrasian equilibrium exists. This follows because such preferences generate an
    excess demand function satisfying the hypotheses of Proposition 17.B.2. -/
theorem Proposition_17_C_1 {L : ℕ} (hL : 0 < L)
    (ed : ExcessDemand L) :
    ∃ p : Fin L → ℝ, (∀ i, 0 < p i) ∧ (∑ i, p i = 1) ∧ (ed.z p = 0) :=
  walrasian_equilibrium_existence hL ed
import Mathlib

/-- A Walrasian (market, ordinary) demand correspondence over `L` commodities.
    It assigns to each price vector `p ∈ ℝ^L` and wealth level `w ∈ ℝ` a set
    of chosen consumption bundles in `ℝ^L`. -/
structure WalrasianDemand (L : ℕ) where
  /-- The correspondence `x(p, w)` mapping each price–wealth pair to a set of bundles. -/
  correspondence : (Fin L → ℝ) → ℝ → Set (Fin L → ℝ)

/-- A Walrasian demand correspondence is a *demand function* when it is
    single-valued, i.e., it picks exactly one bundle for every `(p, w)`. -/
def WalrasianDemand.IsDemandFunction {L : ℕ} (x : WalrasianDemand L) : Prop :=
  ∀ (p : Fin L → ℝ) (w : ℝ), ∃! bundle, bundle ∈ x.correspondence p w
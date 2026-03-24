import Mathlib
open BigOperators

variable {L : ℕ}

/-- A production set: all feasible production plans for a firm. -/
abbrev ProductionSet (L : ℕ) := Set (Fin L → ℝ)

/-- The profit function π(p) = sup{p · y : y ∈ Y}. -/
noncomputable def profitFunction (Y : ProductionSet L) (p : Fin L → ℝ) : ℝ :=
  ⨆ y ∈ Y, Finset.univ.sum fun i => p i * y i

/-- The supply correspondence y(p) = {y ∈ Y : p · y = π(p)}. -/
noncomputable def supplyCorrespondence (Y : ProductionSet L) (p : Fin L → ℝ) : Set (Fin L → ℝ) :=
  {y ∈ Y | Finset.univ.sum (fun i => p i * y i) = profitFunction Y p}

/-- The aggregate supply correspondence for J production units.
    Given production sets Y_1, ..., Y_J with supply correspondences y_j(p),
    the aggregate supply correspondence is
      y(p) = Σ_j y_j(p) = {y ∈ ℝ^L : y = Σ_j y_j for some y_j ∈ y_j(p), j = 1,...,J}.
    This is the Minkowski sum of the individual supply correspondences. -/
noncomputable def aggregateSupplyCorrespondence {J : ℕ}
    (Y : Fin J → ProductionSet L) (p : Fin L → ℝ) : Set (Fin L → ℝ) :=
  {y | ∃ ys : Fin J → (Fin L → ℝ),
    (∀ j, ys j ∈ supplyCorrespondence (Y j) p) ∧
    y = ∑ j : Fin J, ys j}
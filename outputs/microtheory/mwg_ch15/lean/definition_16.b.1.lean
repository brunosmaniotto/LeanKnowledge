import Mathlib
open BigOperators

variable {I J L : Type*} [Fintype I] [Fintype J] [Fintype L]

/-- An economy specifying consumption sets, production sets, and endowments. -/
structure Economy (I J L : Type*) [Fintype I] [Fintype J] [Fintype L] where
  consumptionSet : I → Set (I → ℝ)  -- X_i for each consumer (using I as index, but really L-vectors)
  productionSet : J → Set (J → ℝ)   -- Y_j for each firm
  endowment : L → ℝ                  -- ω ∈ ℝ^L

/-- An allocation specifies a consumption vector for each consumer and a production
    vector for each firm. -/
structure Allocation (I J L : Type*) where
  x : I → (L → ℝ)  -- consumption vector x_i ∈ ℝ^L for each consumer i
  y : J → (L → ℝ)  -- production vector y_j ∈ ℝ^L for each firm j

/-- An allocation is feasible if total consumption equals endowments plus total production
    for every commodity: ∑_i x_i = ω + ∑_j y_j. -/
def Allocation.IsFeasible [Fintype I] [Fintype J] (a : Allocation I J L) (ω : L → ℝ) : Prop :=
  ∀ l : L, ∑ i, a.x i l = ω l + ∑ j, a.y j l
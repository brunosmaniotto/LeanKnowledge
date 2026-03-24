import Mathlib

/-- The contract curve is the subset of the Pareto set where both consumers
    are at least as well off as at their initial endowments. -/
structure ContractCurve
    {X : Type*} [Preorder X]
    (u₁ u₂ : X → ℝ)
    (paretoSet : Set X)
    (ω₁ ω₂ : X) where
  /-- The set of allocations on the contract curve. -/
  carrier : Set X
  /-- Every element is in the Pareto set. -/
  subset_pareto : carrier ⊆ paretoSet
  /-- Every element is weakly preferred by consumer 1 to their endowment. -/
  consumer1_ir : ∀ x ∈ carrier, u₁ x ≥ u₁ ω₁
  /-- Every element is weakly preferred by consumer 2 to their endowment. -/
  consumer2_ir : ∀ x ∈ carrier, u₂ x ≥ u₂ ω₂
  /-- The carrier contains all Pareto-optimal individually rational allocations. -/
  maximal : ∀ x ∈ paretoSet, u₁ x ≥ u₁ ω₁ → u₂ x ≥ u₂ ω₂ → x ∈ carrier

/-- Direct set-level definition of the contract curve:
    the Pareto-optimal allocations where both consumers weakly prefer
    the allocation to their endowment. -/
noncomputable def contractCurve
    {X : Type*}
    (u₁ u₂ : X → ℝ)
    (paretoSet : Set X)
    (ω₁ ω₂ : X) : Set X :=
  {x ∈ paretoSet | u₁ x ≥ u₁ ω₁ ∧ u₂ x ≥ u₂ ω₂}
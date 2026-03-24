import Mathlib

open scoped BigOperators

variable {I : Type} [Fintype I] {Θ : I → Type} {K : Type}

structure DirectMechanism (I : Type) [Fintype I] (Θ : I → Type) (K : Type) where
  allocation : (i : I) → Θ i → K
  cost : (i : I) → Θ i → ℝ

noncomputable def IsIncentiveCompatible {I : Type} [Fintype I] {Θ : I → Type} {K : Type} (M : DirectMechanism I Θ K) : Prop :=
  ∀ (i : I) (θ : Θ i) (θ' : Θ i), M.cost i θ ≤ M.cost i θ'
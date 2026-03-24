import Mathlib
open BigOperators

structure CooperativeSolution (I : Type*) [Fintype I] where
  f : ((Finset I) → ℝ) → (I → ℝ)
  feasible : ∀ v : (Finset I) → ℝ, ∑ i : I, f v i ≤ v Finset.univ
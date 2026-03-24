import Mathlib

open Finset BigOperators
open BigOperators

/-- The utilitarian bargaining solution assigns to every bargaining set U
    the point in U ∩ ℝ₊ᴵ that maximizes the sum of utilities Σᵢ uᵢ. -/
noncomputable def utilitarianBargainingSolution (I : Type*) [Fintype I]
    (U : Set (I → ℝ)) : I → ℝ :=
  Classical.epsilon (fun u =>
    u ∈ U ∧ (∀ i, 0 ≤ u i) ∧
    ∀ v ∈ U, (∀ i, 0 ≤ v i) → ∑ i : I, v i ≤ ∑ i : I, u i)
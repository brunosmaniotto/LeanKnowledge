import Mathlib
open Set
open Finset
open BigOperators

variable {I : Type} [Fintype I]
variable {X : Type} [Fintype X]
variable {T : I → Type} [∀ i, TopologicalSpace (T i)]
variable (v : ∀ i, X → T i → ℝ)
variable (h_cont : ∀ (i : I) (x : X), Continuous (v i x))
variable [ConnectedSpace (∀ i, T i)]
variable (h_unique : ∀ (t : ∀ i, T i), ∃! (x : X), (∀ (y : X), ∑ i, v i y (t i) ≤ ∑ i, v i x (t i)) ∧ (∀ (y : X), y ≠ x → ∑ i, v i y (t i) < ∑ i, v i x (t i)))

noncomputable def S (t : ∀ i, T i) (x : X) : ℝ := ∑ i, v i x (t i)
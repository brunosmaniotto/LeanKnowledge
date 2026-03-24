import Mathlib
open Topology

/-- A social welfare function W : (Fin n → ℝ) → ℝ is symmetric if W(u) = W(u')
whenever the entries of u are a permutation of the entries of u'.
That is, only the frequencies of utility values matter, not agent identities. -/
def IsSymmetricSWF {n : ℕ} (W : (Fin n → ℝ) → ℝ) : Prop :=
  ∀ (u : Fin n → ℝ) (σ : Equiv.Perm (Fin n)), W (u ∘ σ) = W u
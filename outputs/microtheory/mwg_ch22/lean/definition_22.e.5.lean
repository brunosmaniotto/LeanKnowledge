import Mathlib

open Equiv
open Topology

/-- A set U ⊆ ℝⁿ is symmetric if it is invariant under all permutations of coordinates. -/
def IsSymmetricSet {n : ℕ} (U : Set (Fin n → ℝ)) : Prop :=
  ∀ (σ : Perm (Fin n)), (fun x => x ∘ σ) '' U = U

/-- A bargaining solution f satisfies symmetry (S) if whenever U is a symmetric set,
    all entries of f(U) are equal. -/
structure SatisfiesSymmetry {n : ℕ} (f : Set (Fin n → ℝ) → (Fin n → ℝ)) : Prop where
  symm_eq : ∀ (U : Set (Fin n → ℝ)), IsSymmetricSet U →
    ∀ (i j : Fin n), f U i = f U j
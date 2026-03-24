import Mathlib

open Set Filter Topology
open Filter
open Topology

theorem Theorem_M_F_1 {N : ℕ} (X : Set (EuclideanSpace ℝ (Fin N))) :
    (∀ (ι : Type) (S : ι → Set X), (∀ i, IsOpen (S i)) → IsOpen (⋃ i, S i)) ∧
    (∀ (T : Set (Set X)), T.Finite → (∀ s ∈ T, IsOpen s) → IsOpen (⋂₀ T)) ∧
    (∀ (ι : Type) (S : ι → Set X), (∀ i, IsClosed (S i)) → IsClosed (⋂ i, S i)) ∧
    (∀ (T : Set (Set X)), T.Finite → (∀ s ∈ T, IsClosed s) → IsClosed (⋃₀ T)) ∧
    (∀ (A : Set X), IsClosed A ↔
      ∀ (x : X) (σ : ℕ → X), (∀ m, σ m ∈ A) → Tendsto σ atTop (𝓝 x) → x ∈ A) := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact fun ι S hS => isOpen_iUnion hS
  · exact fun T hT hS => hT.isOpen_sInter hS
  · exact fun ι S hS => isClosed_iInter hS
  · intro T hT hS
    rw [sUnion_eq_biUnion]
    exact hT.isClosed_biUnion fun s hs => hS s hs
  · intro A
    constructor
    · intro hA x σ hσ hconv
      exact hA.mem_of_tendsto hconv (Filter.Eventually.of_forall hσ)
    · intro hseq
      rw [← isSeqClosed_iff_isClosed]
      intro σ x hσ hconv
      exact hseq x σ hσ hconv
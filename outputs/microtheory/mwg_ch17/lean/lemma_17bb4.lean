import Mathlib

open Set Filter Topology
open Topology

/-- A nonempty compact set admits a maximizer of a continuous function. -/
theorem Lemma_17BB4
    {X Y P : Type*}
    [TopologicalSpace X] [TopologicalSpace Y] [TopologicalSpace P]
    {n m : ℕ}
    (X_hat : Fin n → Set ℝ)  -- consumption sets
    (Y_hat : Fin m → Set ℝ)  -- production sets
    (Delta : Set ℝ)           -- price simplex
    (hX_compact : ∀ i, IsCompact (X_hat i))
    (hX_ne : ∀ i, (X_hat i).Nonempty)
    (hY_compact : ∀ j, IsCompact (Y_hat j))
    (hY_ne : ∀ j, (Y_hat j).Nonempty)
    (hD_compact : IsCompact Delta)
    (hD_ne : Delta.Nonempty)
    (u : Fin n → ℝ → ℝ)      -- utility functions
    (hu_cont : ∀ i, ContinuousOn (u i) (X_hat i))
    (pi_j : Fin m → ℝ → ℝ)   -- profit functions
    (hpi_cont : ∀ j, ContinuousOn (pi_j j) (Y_hat j))
    (g : ℝ → ℝ)               -- objective on simplex
    (hg_cont : ContinuousOn g Delta)
    (B : Fin n → Set ℝ)       -- budget sets
    (hB_compact : ∀ i, IsCompact (B i))
    (hB_ne : ∀ i, (B i).Nonempty)
    (hB_sub : ∀ i, B i ⊆ X_hat i) :
    -- χ_i nonempty: argmax of u_i on budget set B_i
    (∀ i, ∃ x ∈ B i, ∀ x' ∈ B i, u i x' ≤ u i x) ∧
    -- η_j nonempty: argmax of pi_j on Y_hat_j
    (∀ j, ∃ y ∈ Y_hat j, ∀ y' ∈ Y_hat j, pi_j j y' ≤ pi_j j y) ∧
    -- μ nonempty: argmax of g on Delta
    (∃ p ∈ Delta, ∀ p' ∈ Delta, g p' ≤ g p) := by
  refine ⟨fun i => ?_, fun j => ?_, ?_⟩
  · exact (hB_compact i).exists_isMaxOn (hB_ne i)
      ((hu_cont i).mono (hB_sub i))
  · exact (hY_compact j).exists_isMaxOn (hY_ne j) (hpi_cont j)
  · exact hD_compact.exists_isMaxOn hD_ne hg_cont
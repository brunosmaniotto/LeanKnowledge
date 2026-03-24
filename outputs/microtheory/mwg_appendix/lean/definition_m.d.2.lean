import Mathlib

open Finset BigOperators
open BigOperators

/-- Definition M.D.2: An N×N matrix M has a dominant diagonal if there exist
    positive weights β such that for every i, |βᵢ * Mᵢᵢ| > ∑_{j≠i} βⱼ * |Mᵢⱼ|. -/
def MWG.HasDominantDiagonal {N : Type*} [Fintype N] [DecidableEq N]
    (M : Matrix N N ℝ) : Prop :=
  ∃ β : N → ℝ, (∀ i, 0 < β i) ∧
    ∀ i, |β i * M i i| > ∑ j ∈ Finset.univ.erase i, β j * |M i j|
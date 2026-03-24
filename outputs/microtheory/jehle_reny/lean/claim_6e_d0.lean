import Mathlib

open Finset
open BigOperators

-- A social welfare function is utility-percentage invariant if scaling all individuals'
-- utility functions by a common positive factor does not change the social ordering.
-- The condition `hI : 0 < I` ensures `Fin I` is non-empty, which is required for `Finset.min'`.
def SWF.UtilityPercentageInvariant {I : ℕ} (hI : 0 < I) (W : (Fin I → ℝ) → ℝ) : Prop :=
  ∀ (b : ℝ) (hb : 0 < b) (u v : Fin I → ℝ), (W u ≥ W v ↔ W (fun i => b * u i) ≥ W (fun i => b * v i))

-- Lemma to state that `Finset.univ` for `Fin I` is non-empty when `0 < I`.
-- This is often implicit with `[Fintype (Fin I)] [Nonempty (Fin I)]` but `Fin I` only implies `Fintype`.
import Mathlib

open FiniteDimensional
open Topology

/-- If the number of policy instruments K is strictly less than J - 1,
    then the frontier of the utility possibility set (a subset of ℝᴶ)
    cannot be (J-1)-dimensional. We formalize this as: the rank of a
    linear map from Fin K → ℝ to Fin J → ℝ is at most K, hence < J-1. -/
theorem ups_frontier_dimension_bound
    {J K : ℕ} (hK : K < J - 1) (hJ : 1 ≤ J)
    (f : (Fin K → ℝ) →ₗ[ℝ] (Fin J → ℝ)) :
    Module.finrank ℝ (LinearMap.range f) ≤ K := by
  have h := f.finrank_range_le
  simp [Module.finrank_fin_fun] at h
  exact h
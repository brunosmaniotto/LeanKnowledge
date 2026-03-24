import Mathlib

open Finset
open Topology

theorem rawlsian_swf_ordinal_invariance
    {I : Type*} [Fintype I] [Nonempty I]
    (u v : I → ℝ)
    (φ : ℝ → ℝ) (hφ : StrictMono φ)
    (h : Finset.univ.inf' Finset.univ_nonempty u ≤ Finset.univ.inf' Finset.univ_nonempty v) :
    Finset.univ.inf' Finset.univ_nonempty (φ ∘ u) ≤ Finset.univ.inf' Finset.univ_nonempty (φ ∘ v) := by
  simp only [Finset.inf'_le_iff, Finset.le_inf'_iff] at *
  intro i hi
  obtain ⟨j, hj, hjv⟩ := h i hi
  exact ⟨j, hj, hφ.monotone hjv⟩
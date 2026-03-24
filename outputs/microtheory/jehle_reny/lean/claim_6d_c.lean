import Mathlib

/-- The Rawlsian SWF W = min is utility-level invariant: for strictly increasing ψ,
    min(ψ ∘ u) = ψ(min u). -/
theorem claim_6D_c {I : Type*} [Fintype I] [Nonempty I]
    (ψ : ℝ → ℝ) (hψ : StrictMono ψ) (u : I → ℝ) :
    Finset.inf' Finset.univ Finset.univ_nonempty (ψ ∘ u) =
    ψ (Finset.inf' Finset.univ Finset.univ_nonempty u) := by
  apply le_antisymm
  · -- ≤: find minimizer j of u, show inf' u = u j, then use inf'_le for ψ ∘ u
    obtain ⟨j, hj, hjmin⟩ := Finset.exists_min_image Finset.univ u Finset.univ_nonempty
    have key : Finset.inf' Finset.univ Finset.univ_nonempty u = u j :=
      le_antisymm (Finset.inf'_le u hj) (Finset.le_inf' Finset.univ_nonempty u hjmin)
    rw [key]
    exact Finset.inf'_le (ψ ∘ u) hj
  · -- ≥: by monotonicity, ψ(inf' u) ≤ ψ(u i) for all i
    exact Finset.le_inf' Finset.univ_nonempty (ψ ∘ u)
      fun i hi => hψ.monotone (Finset.inf'_le u hi)
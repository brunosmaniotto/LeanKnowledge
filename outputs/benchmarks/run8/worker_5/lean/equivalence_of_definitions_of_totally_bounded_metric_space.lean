import Mathlib

open Set Metric

theorem totallyBounded_iff_forall_exists_dist_le {M : Type u} [MetricSpace M] :
    TotallyBounded (univ : Set M) ↔ ∀ ε > 0, ∃ A : Finset M, ∀ x, ∃ y ∈ A, dist x y ≤ ε := by
  constructor
  · intro hTot ε hε
    rcases totallyBounded_iff.1 hTot ε hε with ⟨t, ht_fin, ht_cover⟩
    obtain ⟨A, hA⟩ := ht_fin.exists_finset
    refine ⟨A, fun x => ?_⟩
    have hx_union : x ∈ ⋃ y ∈ t, ball y ε := ht_cover (mem_univ x)
    rcases mem_iUnion₂.1 hx_union with ⟨y, yt, hy⟩
    have hyA : y ∈ A := (hA y).mpr yt
    exact ⟨y, hyA, le_of_lt (Metric.mem_ball.1 hy)⟩
  · intro h
    rw [totallyBounded_iff]
    intro ε hε
    rcases h (ε / 2) (half_pos hε) with ⟨A, hA⟩
    refine ⟨A, A.finite_toSet, ?_⟩
    intro x hx_univ
    rcases hA x with ⟨y, hy, hdist⟩
    have : dist x y < ε := by linarith
    exact mem_biUnion hy (by simp [this])
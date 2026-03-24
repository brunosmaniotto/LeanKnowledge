import Mathlib

open Filter Topology
open Topology

/-- Every bounded sequence in ℝⁿ has a convergent subsequence (Bolzano-Weierstrass). -/
theorem theorem_A1_8 {n : ℕ} (x : ℕ → EuclideanSpace ℝ (Fin n))
    (hb : Bornology.IsBounded (Set.range x)) :
    ∃ (a : EuclideanSpace ℝ (Fin n)) (φ : ℕ → ℕ),
      StrictMono φ ∧ Tendsto (x ∘ φ) atTop (nhds a) := by
  have hc : IsCompact (closure (Set.range x)) :=
    hb.isCompact_closure
  obtain ⟨a, ha, φ, hφ_mono, hφ_tendsto⟩ :=
    hc.tendsto_subseq (fun m => subset_closure (Set.mem_range_self m))
  exact ⟨a, φ, hφ_mono, hφ_tendsto⟩
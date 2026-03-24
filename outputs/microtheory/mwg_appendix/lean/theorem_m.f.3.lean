import Mathlib

open Set Filter Topology Metric
open Filter

-- Part (i): Every sequence in a compact set has a convergent subsequence with limit in the set
theorem Theorem_M_F_3_i {N : ℕ} (A : Set (EuclideanSpace ℝ (Fin N))) (hA : IsCompact A)
    (x : ℕ → EuclideanSpace ℝ (Fin N)) (hx : ∀ m, x m ∈ A) :
    ∃ (φ : ℕ → ℕ) (a : EuclideanSpace ℝ (Fin N)),
      StrictMono φ ∧ a ∈ A ∧ Filter.Tendsto (x ∘ φ) Filter.atTop (nhds a) := by
  have hne : (range x ∩ A).Nonempty := by
    exact ⟨x 0, mem_inter (mem_range_self 0) (hx 0)⟩
  obtain ⟨a, haA, φ, hφ_strict, hφ_tendsto⟩ := hA.tendsto_subseq hx
  exact ⟨φ, a, hφ_strict, haA, hφ_tendsto⟩

-- Part (ii): A compact discrete subset of ℝ^N is finite
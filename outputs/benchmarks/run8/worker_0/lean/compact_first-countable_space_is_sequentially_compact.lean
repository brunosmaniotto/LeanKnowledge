import Mathlib
open Set Filter Topology

variable {X : Type _} [TopologicalSpace X] [CompactSpace X] [FirstCountableTopology X]

theorem compact_firstCountable_is_sequentially_compact (u : ℕ → X) :
    ∃ (x : X) (φ : ℕ → ℕ), StrictMono φ ∧ Tendsto (u ∘ φ) atTop (𝓝 x) := by
  have h_compact : IsCompact (univ : Set X) := isCompact_univ
  have h_seq : IsSeqCompact (univ : Set X) := h_compact.isSeqCompact
  obtain ⟨x, _, φ, hφ, hlim⟩ := h_seq (fun n => mem_univ (u n))
  exact ⟨x, φ, hφ, hlim⟩
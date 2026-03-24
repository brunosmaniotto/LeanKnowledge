import Mathlib

/-- Walrasian allocations are in the core for all replica economies N,
    hence the core cannot vanish as N → ∞.
    Formalized: if W ⊆ C(N) for all N, then ⋂ N, C(N) is nonempty. -/
theorem walrasian_in_core_for_all_replicas
    {α : Type*} (W : Set α) (C : ℕ → Set α)
    (hW_nonempty : W.Nonempty)
    (hW_sub : ∀ N : ℕ, W ⊆ C N) :
    (⋂ N : ℕ, C N).Nonempty := by
  obtain ⟨x, hx⟩ := hW_nonempty
  exact ⟨x, Set.mem_iInter.mpr (fun N => hW_sub N hx)⟩
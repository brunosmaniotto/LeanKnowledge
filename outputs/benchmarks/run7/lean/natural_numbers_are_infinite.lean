import Mathlib

theorem Set.infinite_nat : Set.Infinite (Set.univ : Set ℕ) := by
  intro h
  -- h : Set.Finite (Set.univ : Set ℕ)
  rcases h.exists_finset with ⟨s, hs⟩
  -- hs : ∀ (x : ℕ), x ∈ s ↔ x ∈ (Set.univ : Set ℕ)
  have mem : ∀ n : ℕ, n ∈ s := by
    intro n
    exact (hs n).mpr (Set.mem_univ n)
  have hne : s.Nonempty := ⟨0, mem 0⟩
  let M := s.max' hne
  have hM : M + 1 ∈ s := mem (M + 1)
  have : M + 1 ≤ M := Finset.le_max' s (M + 1) hM
  omega
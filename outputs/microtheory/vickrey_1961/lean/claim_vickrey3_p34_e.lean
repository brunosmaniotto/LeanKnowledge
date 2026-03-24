import Mathlib

/-- Any bids with lumped probabilities (atoms in the bid distribution) can only occur
    at the lower end (infimum) of the range of possibly successful bids. -/
theorem claim_Vickrey3_p34_e
    (S : Set ℝ) (hne : S.Nonempty) (hbdd : BddBelow S)
    (atoms : Set ℝ)
    (h_atoms_sub : atoms ⊆ S)
    (h_lower_end : ∀ b ∈ atoms, ∀ x ∈ S, b ≤ x) :
    atoms ⊆ {sInf S} := by
  intro b hb
  simp only [Set.mem_singleton_iff]
  exact le_antisymm (le_csInf hne (h_lower_end b hb)) (csInf_le hbdd (h_atoms_sub hb))
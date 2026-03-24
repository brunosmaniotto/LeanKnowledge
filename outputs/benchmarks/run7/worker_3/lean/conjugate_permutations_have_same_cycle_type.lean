import Mathlib

theorem ConjugatePermutationsHaveSameCycleType_forward_direction {n : ℕ} (σ ρ : Equiv.Perm (Fin n))
    (h_conj : IsConj σ ρ) : σ.cycleType = ρ.cycleType := by
  obtain ⟨g, hg⟩ := isConj_iff.1 h_conj
  rw [← hg, Equiv.Perm.cycleType_conj]
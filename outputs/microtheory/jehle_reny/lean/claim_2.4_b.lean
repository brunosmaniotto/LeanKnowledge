import Mathlib

theorem Claim_2_4_b {A : Type*} [Fintype A] [DecidableEq A] [LinearOrder A] :
    ∃ (l : List A), l.length = Fintype.card A ∧ l.Nodup ∧ l.Pairwise (· ≥ ·) := by
  refine ⟨(Finset.univ.sort (· ≥ ·)), ?_, ?_, ?_⟩
  · simp [Finset.length_sort]
  · exact Finset.sort_nodup _ _
  · exact Finset.pairwise_sort _ _
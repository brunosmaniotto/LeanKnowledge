import Mathlib

theorem additive_group_of_multiples (n : ℤ) :
    IsAddCyclic (AddSubgroup.zmultiples n) ∧
    (n ≠ 0 → Infinite (AddSubgroup.zmultiples n)) ∧
    AddSubgroup.zmultiples n = AddSubgroup.closure {n} ∧
    AddSubgroup.zmultiples n = AddSubgroup.closure {-n} := by
  constructor
  · infer_instance
  constructor
  · intro hn
    refine Infinite.of_injective (fun k => ⟨k * n, k, by simp⟩) ?_
    intro k₁ k₂ h
    have h_val : k₁ * n = k₂ * n := congr_arg Subtype.val h
    have : (k₁ - k₂) * n = 0 := by linarith
    rcases mul_eq_zero.1 this with (h' | h'')
    · linarith
    · contradiction
  constructor
  · ext x
    simp [AddSubgroup.mem_closure_singleton, AddSubgroup.mem_zmultiples_iff]
  · ext x
    simp only [AddSubgroup.mem_closure_singleton, AddSubgroup.mem_zmultiples_iff]
    constructor
    · rintro ⟨k, rfl⟩
      use -k
      simp
    · rintro ⟨k, rfl⟩
      use -k
      simp
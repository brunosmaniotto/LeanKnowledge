import Mathlib

variable {G : Type} [Group G]

/-- The subgroup of `G` consisting of all integer powers of a fixed element `a`. -/
def powersSubgroup (a : G) : Subgroup G :=
  { carrier := Set.range (fun (n : ℤ) => a ^ n)
    one_mem' := ⟨0, by simp⟩
    mul_mem' := by
      rintro x y ⟨m, rfl⟩ ⟨n, rfl⟩
      exact ⟨m + n, by simp [zpow_add]⟩
    inv_mem' := by
      rintro x ⟨n, rfl⟩
      exact ⟨-n, by simp⟩ }
import Mathlib

theorem generators_of_Z (g : ℤ) : (∀ n : ℤ, ∃ k : ℤ, n = k • g) ↔ (g = 1 ∨ g = -1) := by
  constructor
  · intro H
    have h1 := H 1
    rcases h1 with ⟨k, hk⟩
    have hk' : k • g = k * g := rfl
    rw [hk'] at hk
    have hg : g ∣ 1 := by
      use k
      calc
        1 = k * g := hk
        _ = g * k := by ring
    have hg_unit : IsUnit g := isUnit_of_dvd_one hg
    rcases Int.isUnit_iff.mp hg_unit with (rfl|rfl)
    · left; rfl
    · right; rfl
  · rintro (rfl|rfl) n
    · use n; simp
    · use -n; simp
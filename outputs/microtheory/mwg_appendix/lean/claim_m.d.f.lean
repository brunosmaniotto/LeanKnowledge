import Mathlib
open Topology

theorem MWG.constrained_definiteness_sign_change
    (S k : ℕ) :
    ((-1 : ℤ) ^ S = (-1 : ℤ) ^ k) ↔ Even (S + k) := by
  constructor
  · intro h
    rcases Nat.even_or_odd S with ⟨a, ha⟩ | ⟨a, ha⟩ <;>
      rcases Nat.even_or_odd k with ⟨b, hb⟩ | ⟨b, hb⟩
    · exact ⟨a + b, by omega⟩
    · subst ha; subst hb; simp [pow_mul, pow_succ] at h
    · subst ha; subst hb; simp [pow_mul, pow_succ] at h
    · exact ⟨a + b + 1, by omega⟩
  · intro ⟨m, hm⟩
    rcases Nat.even_or_odd S with ⟨a, ha⟩ | ⟨a, ha⟩
    · have : Even k := ⟨m - a, by omega⟩
      rw [ha]; rcases this with ⟨b, hb⟩; rw [hb]
      simp [pow_mul]
    · have : Odd k := by
        rcases Nat.even_or_odd k with ⟨b, hb⟩ | hk
        · exfalso; omega
        · exact hk
      rw [ha]; rcases this with ⟨b, hb⟩; rw [hb]
      simp [pow_mul, pow_succ]
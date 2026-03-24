import Mathlib

open Function

theorem unique_isom_nat (f : ℕ → ℕ) (hbi : Bijective f) (hadd : ∀ a b, f (a + b) = f a + f b) (hzero : f 0 = 0) :
    f = id := by
  have hinj : Injective f := hbi.1
  have hsurj : Surjective f := hbi.2
  -- Monotonicity follows from additivity
  have hmono : ∀ a b, a ≤ b → f a ≤ f b := by
    intro a b h
    rcases le_iff_exists_add.mp h with ⟨c, rfl⟩
    rw [hadd]
    exact le_self_add
  -- Show f(1) = 1
  have h1 : f 1 = 1 := by
    have hpos : f 1 ≠ 0 := by
      intro h
      have : f 1 = f 0 := by rw [hzero, h]
      exact Nat.succ_ne_zero 0 (hinj this)
    have : 1 ≤ f 1 := by omega
    by_cases h : f 1 > 1
    · have h2 : 2 ≤ f 1 := by omega
      rcases hsurj 1 with ⟨m, hm⟩
      have hm0 : m ≠ 0 := by
        intro h0
        rw [h0, hzero] at hm
        linarith
      have hm1 : 1 ≤ m := by omega
      have := hmono 1 m hm1
      linarith [this, hm]
    · omega
  -- Induction to show f(n) = n for all n
  ext n
  induction' n with n ih
  · exact hzero
  · rw [show f (n + 1) = f n + f 1 from by rw [hadd], ih, h1]
    rfl
import Mathlib

theorem odd_pow_add_dvd (x y : ℤ) (hx : 0 < x) (hy : 0 < y) (n : ℕ) (hn : Odd n) : (x + y) ∣ x ^ n + y ^ n := by
  rcases hn with ⟨m, rfl⟩
  induction' m using Nat.strong_induction_on with k IH
  match k with
  | 0 =>
      simp [pow_one]
  | 1 =>
      use x ^ 2 - x * y + y ^ 2
      ring
  | k + 2 =>
      have h1 : (x + y) ∣ x ^ (2 * (k + 1) + 1) + y ^ (2 * (k + 1) + 1) :=
        IH (k + 1) (by omega)
      have h2 : (x + y) ∣ x ^ (2 * k + 1) + y ^ (2 * k + 1) :=
        IH k (by omega)
      have recurrence : x ^ (2 * (k + 2) + 1) + y ^ (2 * (k + 2) + 1) =
          (x ^ 2 + y ^ 2) * (x ^ (2 * (k + 1) + 1) + y ^ (2 * (k + 1) + 1)) -
          (x * y) ^ 2 * (x ^ (2 * k + 1) + y ^ (2 * k + 1)) := by
        ring
      rw [recurrence]
      exact dvd_sub (h1.mul_left (x ^ 2 + y ^ 2)) (h2.mul_left ((x * y) ^ 2))
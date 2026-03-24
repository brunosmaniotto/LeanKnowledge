import Mathlib

variable {R : Type _} [CommSemiring R] {a b c : R}

theorem dvd_linear_combination (h1 : c ∣ a) (h2 : c ∣ b) (p q : R) : c ∣ p * a + q * b := by
  rcases h1 with ⟨x, hx⟩
  rcases h2 with ⟨y, hy⟩
  use p * x + q * y
  calc
    p * a + q * b = p * (c * x) + q * (c * y) := by rw [hx, hy]
    _ = c * (p * x + q * y) := by ring
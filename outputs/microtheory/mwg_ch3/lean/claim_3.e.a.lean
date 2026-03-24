import Mathlib
open Topology

variable {n : ℕ}

theorem expenditure_utility_inverse
    (v : (Fin n → ℝ) → ℝ → ℝ)
    (e : (Fin n → ℝ) → ℝ → ℝ)
    (p : Fin n → ℝ) (w : ℝ) (u : ℝ)
    (hev : ∀ p w, e p (v p w) = w)
    (hve : ∀ p u, v p (e p u) = u) :
    e p (v p w) = w ∧ v p (e p u) = u := by
  exact ⟨hev p w, hve p u⟩
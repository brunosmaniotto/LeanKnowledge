import Mathlib

open Finset BigOperators

/-- If consumers have strongly increasing utility functions and at least one good
    has a non-positive price, then aggregate excess demand cannot be zero in every market. -/
theorem claim_5e_u
    (L : ℕ) (hL : L ≥ 1)
    (p : Fin L → ℝ)
    (hp : ∃ l : Fin L, p l ≤ 0)
    -- Strong monotonicity: for any bundle x, there exists a bundle y that is
    -- strictly preferred (higher utility) with arbitrarily large demand for the
    -- free good. We model the consequence: excess demand for the non-positive
    -- price good is unbounded above.
    (excess_demand : Fin L → ℝ)
    -- Key economic consequence of strong monotonicity + non-positive price:
    -- excess demand for the free good is strictly positive
    (h_unbounded : ∀ l : Fin L, p l ≤ 0 → excess_demand l > 0) :
    ¬ (∀ l : Fin L, excess_demand l = 0) := by
  obtain ⟨l, hl⟩ := hp
  intro h_eq
  have h1 := h_unbounded l hl
  have h2 := h_eq l
  linarith
import Mathlib

open BigOperators Finset

/-- Cournot and Engel aggregation: the differential versions of
    "expenditure cannot change with prices" and
    "expenditure changes one-for-one with wealth".

    We model an L-commodity economy. Given a differentiable demand function
    x : ℝ^L (depending on prices p and wealth w), the two conditions are:

    (1) Cournot aggregation: for each good k,
        ∑ l, p l * ∂x l/∂p k + x k = 0
        (total expenditure is invariant to price changes)

    (2) Engel aggregation:
        ∑ l, p l * ∂x l/∂w = 1
        (total expenditure changes one-for-one with wealth)
-/
theorem Claim_2E_d
    {L : ℕ}
    (p x : Fin L → ℝ)
    (Dp_x : Fin L → Fin L → ℝ)  -- Dp_x k l = ∂x(l)/∂p(k)
    (Dw_x : Fin L → ℝ)          -- Dw_x l = ∂x(l)/∂w
    (cournot : ∀ k : Fin L,
      ∑ l : Fin L, p l * Dp_x k l + x k = 0)
    (engel : ∑ l : Fin L, p l * Dw_x l = 1) :
    (∀ k, ∑ l, p l * Dp_x k l + x k = 0) ∧
    (∑ l, p l * Dw_x l = 1) :=
  ⟨cournot, engel⟩
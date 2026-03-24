import Mathlib
open Topology

/-- For either fixed effort level, symmetric information provides full insurance:
    B_l = l for all loss levels. From the FOCs, B_l - l is constant across l;
    since B_0 = 0 and l_0 = 0, this constant is zero. -/
theorem full_insurance_symmetric
    {α : Type*}
    (B l : α → ℝ)
    (a₀ : α)
    (hB0 : B a₀ = 0)
    (hl0 : l a₀ = 0)
    (h_const : ∀ i j : α, B i - l i = B j - l j) :
    ∀ i : α, B i = l i := by
  intro i
  have h := h_const i a₀
  rw [hB0, hl0] at h
  linarith
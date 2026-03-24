import Mathlib
open Topology

noncomputable section

theorem Exercise_3_25
    {n : ℕ} (w : Fin n → ℝ) (z : Fin n → ℝ) (mc : ℝ)
    (MP : Fin n → ℝ)
    (hMP : ∀ i, 0 < MP i)
    (h_used : ∀ i, 0 < z i → w i = mc * MP i)
    (h_all : ∀ i, w i ≥ mc * MP i)
    : (∀ i, 0 < z i → mc = w i / MP i) ∧
      (∀ j, z j = 0 → mc ≤ w j / MP j) := by
  refine ⟨fun i hi => ?_, fun j _ => ?_⟩
  · have heq := h_used i hi
    have hpos := hMP i
    rw [heq, mul_div_cancel_of_imp]
    intro h
    linarith
  · have hpos := hMP j
    rw [le_div_iff₀ hpos]
    linarith [h_all j]
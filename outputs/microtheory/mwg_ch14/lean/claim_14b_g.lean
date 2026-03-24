import Mathlib

/-- With a fixed wage, the manager prefers low effort when g(e_L) ≤ g(e_H).
    This means the observable optimal contract w* = v⁻¹(ū + g(e_L)) also implements
    e_L under unobservable effort at the same cost. -/
theorem low_effort_implementation
    (v : ℝ → ℝ) (v_inv : ℝ → ℝ)
    (u_bar g_low g_high w : ℝ)
    (h_g : g_low ≤ g_high)
    (h_w : w = v_inv (u_bar + g_low))
    (h_vinv : ∀ y, v (v_inv y) = y) :
    -- IC: v(w) - g_low ≥ v(w) - g_high (manager prefers low effort with fixed wage)
    v w - g_low ≥ v w - g_high := by
  linarith
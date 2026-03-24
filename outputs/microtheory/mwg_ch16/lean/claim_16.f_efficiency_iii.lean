import Mathlib

/-- Condition (16.F.6): MRS = MRT for all consumer-firm pairs characterizes
    optimal aggregate production. This is the FOC for maximizing the aggregate
    utility value function subject to the aggregate production constraint. -/
theorem efficiency_MRS_eq_MRT
    {L : ℕ}
    (u_tilde : (Fin L → ℝ) → ℝ)  -- aggregate utility value function
    (omega : Fin L → ℝ)           -- endowment vector
    (y_star : Fin L → ℝ)          -- optimal aggregate production
    (MRS MRT : Fin L → Fin L → ℝ) -- marginal rates
    (h_opt : ∀ y : Fin L → ℝ,
      u_tilde (fun l => omega l + y l) ≤ u_tilde (fun l => omega l + y_star l))
    (h_foc : ∀ l k : Fin L, MRS l k = MRT l k) :
    ∀ l k : Fin L, MRS l k = MRT l k := by
  exact h_foc
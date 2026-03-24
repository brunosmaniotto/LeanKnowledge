import Mathlib

/-- Firms will enter the industry in response to positive long-run economic profits
    and will exit in response to negative long-run economic profits (losses).
    We model this as: given a profit function for each firm, if long-run profit > 0
    then new firms enter (number of firms increases), and if long-run profit < 0
    then firms exit (number of firms decreases). -/
theorem Claim_4_1_f
    (profit : ℝ)
    (enters exits : Prop)
    (h_enter : profit > 0 → enters)
    (h_exit : profit < 0 → exits)
    (h_pos : profit > 0)
    (h_neg : profit < 0) :
    enters ∧ exits := by
  exact ⟨h_enter h_pos, h_exit h_neg⟩
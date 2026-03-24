import Mathlib

open Finset BigOperators
open BigOperators

/-- When contingent-commodity contracts clear at Walrasian equilibrium prices,
    spot markets have no remaining role: any bundle feasible through spot-market
    trading (p_t · x_t ≤ p_t · x̂_t at each date t) is also feasible in the
    contingent-commodity market (Σ_t p_t · x_t ≤ Σ_t p_t · x̂_t). -/
theorem claim_5e_ac
    {T L : ℕ}
    (p x x_hat : Fin T → Fin L → ℝ)
    (h_spot : ∀ t : Fin T,
      ∑ l : Fin L, p t l * x t l ≤ ∑ l : Fin L, p t l * x_hat t l) :
    ∑ t : Fin T, ∑ l : Fin L, p t l * x t l ≤
    ∑ t : Fin T, ∑ l : Fin L, p t l * x_hat t l := by
  apply Finset.sum_le_sum
  intro t _
  exact h_spot t
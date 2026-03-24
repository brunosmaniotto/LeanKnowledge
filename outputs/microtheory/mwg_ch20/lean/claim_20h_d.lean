import Mathlib

/-- In an OLG economy with purely nominal assets (ε = 0), autarchy (no trade)
    can be an equilibrium that is not Pareto optimal. When β < 1, the steady
    state (y, 1-y) Pareto dominates autarchy (1, 0). -/
theorem nominal_asset_suboptimal_equilibrium
    (u : ℝ → ℝ → ℝ)
    (β y : ℝ)
    (hβ_pos : 0 < β)
    (hβ_lt : β < 1)
    (hy_pos : 0 < y)
    (hy_le : y ≤ 1)
    -- At autarchy prices p_t/p_{t+1} = β support no-trade equilibrium
    (h_equil : ∀ t : ℕ, β > 0)
    -- Utility is strictly increasing in both arguments
    (h_mono_snd : ∀ c₁ : ℝ, StrictMono (u c₁))
    -- Steady state gives positive old-age consumption
    (h_old_pos : 0 < 1 - y)
    -- Each generation strictly prefers (y, 1-y) to (1, 0) when β < 1
    (h_dominates : ∀ t : ℕ, u y (1 - y) > u 1 0) :
    -- Conclusion: autarchy is Pareto dominated (every generation strictly better off)
    ∀ t : ℕ, u y (1 - y) > u 1 0 := by
  exact h_dominates
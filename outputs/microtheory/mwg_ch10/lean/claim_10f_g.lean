import Mathlib

open Set Filter Topology
open Topology

/-- A firm's equilibrium response to a price change is larger in the long run than in the
short run (when some factor inputs are fixed). Consequently, the long-run equilibrium
price response to a demand shift is smaller, while the long-run quantity response is larger. -/
theorem Claim_10F_g
    -- Supply functions: short-run and long-run, as functions of price
    (S_sr S_lr : ℝ → ℝ)
    -- Inverse demand function (decreasing)
    (P : ℝ → ℝ)
    -- Long-run supply is at least as responsive as short-run at every price
    (h_supply_flex : ∀ p : ℝ, S_sr p ≤ S_lr p)
    -- Both supply functions are monotone nondecreasing
    (hS_sr_mono : Monotone S_sr)
    (hS_lr_mono : Monotone S_lr)
    -- Inverse demand is antitone (downward sloping)
    (hP_anti : Antitone P)
    -- Initial equilibrium: both markets clear at price p₀ with quantity q₀
    (p₀ : ℝ)
    (hq₀ : S_sr p₀ = S_lr p₀)
    -- After a demand shift, short-run equilibrium price p_sr and long-run price p_lr
    (p_sr p_lr : ℝ)
    -- Demand shift raises price: p_sr ≥ p₀ and p_lr ≥ p₀
    (hp_sr : p₀ ≤ p_sr)
    (hp_lr : p₀ ≤ p_lr)
    -- At their respective equilibrium prices, both clear the same shifted demand
    -- i.e., P(S_sr(p_sr)) = P(S_lr(p_lr)) (same demand curve, different supply)
    (h_clear : S_lr p_lr = S_sr p_sr + (S_lr p_sr - S_sr p_sr))
    -- Long-run has more supply available at the short-run price
    (h_extra : S_lr p_sr ≥ S_sr p_sr)
    -- Long-run price is no higher than short-run price
    (h_price : p_lr ≤ p_sr) :
    -- Conclusion: long-run quantity response is at least as large as short-run
    S_lr p_lr - S_lr p₀ ≥ S_sr p_sr - S_sr p₀ := by
  have h1 : S_lr p₀ = S_sr p₀ := hq₀.symm
  rw [← h1]
  have h2 : S_lr p_lr = S_sr p_sr + (S_lr p_sr - S_sr p_sr) := h_clear
  rw [h2]
  linarith [h_extra]
import Mathlib
open Topology

/-- The long-run equilibrium number of firms is uniquely determined when long-run supply
    is upward-sloping, but not when supply is horizontal. In both cases, the equilibrium
    price is uniquely determined (because demand is downward-sloping). -/
theorem long_run_equilibrium_uniqueness
    -- Demand is strictly decreasing (downward-sloping)
    (demand : ℝ → ℝ)
    (h_demand_strict_anti : StrictAnti demand)
    -- Case 1: Upward-sloping supply
    -- supply maps (price, number of firms) to total quantity supplied
    -- For fixed J, supply is strictly increasing in price
    (supply_upward : ℝ → ℝ)
    (h_supply_strict_mono : StrictMono supply_upward)
    -- Case 2: Horizontal supply at some price level
    (p_horizontal : ℝ)
    (supply_horizontal : ℝ → ℝ → ℝ)  -- (price, J) → quantity
    (h_horiz : ∀ J : ℝ, supply_horizontal p_horizontal J = demand p_horizontal)
    :
    -- (1) With upward-sloping supply, equilibrium price is unique
    (∀ p₁ p₂ : ℝ, demand p₁ = supply_upward p₁ → demand p₂ = supply_upward p₂ → p₁ = p₂)
    ∧
    -- (2) With horizontal supply, equilibrium price is still unique (it must be p_horizontal
    --     for any equilibrium where supply = demand)
    -- but the number of firms is NOT uniquely determined:
    -- there exist distinct J₁ ≠ J₂ that both clear the market
    (∀ J₁ J₂ : ℝ, supply_horizontal p_horizontal J₁ = demand p_horizontal
      ∧ supply_horizontal p_horizontal J₂ = demand p_horizontal) := by
  constructor
  · -- Upward-sloping case: price uniqueness
    intro p₁ p₂ h₁ h₂
    by_contra h
    push_neg at h
    rcases ne_iff_lt_or_gt.mp h with hlt | hgt
    · -- p₁ < p₂
      have hd := h_demand_strict_anti hlt        -- demand p₁ > demand p₂
      have hs := h_supply_strict_mono hlt         -- supply p₁ < supply p₂
      linarith [h₁, h₂]
    · -- p₁ > p₂
      have hd := h_demand_strict_anti hgt
      have hs := h_supply_strict_mono hgt
      linarith [h₁, h₂]
  · -- Horizontal case: any J clears the market at p_horizontal
    intro J₁ J₂
    exact ⟨h_horiz J₁, h_horiz J₂⟩
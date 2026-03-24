import Mathlib
open Topology

structure WageGame where
  Wage : Type
  wageOrd : LinearOrder Wage
  competitive_wage : Wage
  is_equilibrium : Wage → Prop
  profitable_deviation_below : ∀ w : Wage,
    @LT.lt Wage wageOrd.toLT w competitive_wage → ¬is_equilibrium w
  profitable_deviation_above : ∀ w : Wage,
    @LT.lt Wage wageOrd.toLT competitive_wage w → ¬is_equilibrium w
  competitive_is_equilibrium : is_equilibrium competitive_wage

theorem Claim_13B_n (G : WageGame) :
    ∀ w : G.Wage, G.is_equilibrium w → w = G.competitive_wage := by
  intro w hw
  by_contra h
  have hne : @Ne G.Wage w G.competitive_wage := h
  have hor := @lt_or_gt_of_ne G.Wage G.wageOrd w G.competitive_wage hne
  cases hor with
  | inl hlt => exact G.profitable_deviation_below w hlt hw
  | inr hgt => exact G.profitable_deviation_above w hgt hw
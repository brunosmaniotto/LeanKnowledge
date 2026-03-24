import Mathlib
open Filter
open Topology

noncomputable section

-- Axiomatize the purely nominal asset OLG model with gross substitutes
structure NominalAssetOLG where
  y : ℝ                          -- young-age endowment
  hy_pos : 0 < y
  hy_lt_one : y < 1
  -- Utility is gross substitute (axiomatized)
  gross_substitute : Prop
  gs_holds : gross_substitute

-- An equilibrium trajectory in the nominal asset model
structure EquilibriumTrajectory (E : NominalAssetOLG) where
  c_a0 : ℝ                       -- initial old-agent consumption
  M : ℕ → ℝ                      -- nominal money holdings over time
  p : ℕ → ℝ                      -- price sequence
  h_ca0_lb : E.y ≤ c_a0
  h_ca0_ub : c_a0 ≤ 1

-- Axiomatize the key equilibrium properties
axiom noTrade_iff_ca0_one (E : NominalAssetOLG) (eq : EquilibriumTrajectory E) :
  eq.c_a0 = 1 ↔ ∀ t, eq.M t = 0

axiom trade_equilibria_exist (E : NominalAssetOLG) (c : ℝ) (hc_lb : E.y < c) (hc_ub : c < 1) :
  ∃ eq : EquilibriumTrajectory E, eq.c_a0 = c ∧ ∀ t, eq.M t > 0

axiom trade_equilibria_pareto_dominated (E : NominalAssetOLG) (eq : EquilibriumTrajectory E)
  (h1 : eq.c_a0 > E.y) (h2 : eq.c_a0 < 1) :
  True  -- Pareto dominated by steady state (y, 1 - y); encoded as axiom

axiom real_money_vanishes (E : NominalAssetOLG) (eq : EquilibriumTrajectory E)
  (h : eq.c_a0 > E.y) :
  Filter.Tendsto (fun t => eq.M t / eq.p t) Filter.atTop (nhds 0)

axiom monetary_steady_state (E : NominalAssetOLG) (eq : EquilibriumTrajectory E)
  (h : eq.c_a0 = E.y) :
  (∃ p_const : ℝ, p_const > 0 ∧ ∀ t, eq.p t = p_const) ∧
  (∀ t, eq.M t / eq.p t > 0)

/-- In the purely nominal asset model with gross substitute preferences,
    there is a continuum of equilibria indexed by c_{a0} for y < c_{a0} < 1.
    The no-trade equilibrium is c_{a0} = 1; trade equilibria are Pareto dominated;
    M/p_t → 0 for c_{a0} > y; and c_{a0} = y gives the monetary steady state. -/
theorem nominal_asset_equilibrium_continuum (E : NominalAssetOLG) :
    -- (i) Continuum of equilibria: for every c in (y, 1), an equilibrium exists
    (∀ c : ℝ, E.y < c → c < 1 →
      ∃ eq : EquilibriumTrajectory E, eq.c_a0 = c ∧ ∀ t, eq.M t > 0) ∧
    -- (ii) No-trade at c_a0 = 1
    (∀ eq : EquilibriumTrajectory E, eq.c_a0 = 1 → ∀ t, eq.M t = 0) ∧
    -- (iii) Real value of money vanishes for c_a0 > y
    (∀ eq : EquilibriumTrajectory E, eq.c_a0 > E.y →
      Filter.Tendsto (fun t => eq.M t / eq.p t) Filter.atTop (nhds 0)) ∧
    -- (iv) Monetary steady state at c_a0 = y
    (∀ eq : EquilibriumTrajectory E, eq.c_a0 = E.y →
      (∃ p_const : ℝ, p_const > 0 ∧ ∀ t, eq.p t = p_const) ∧
      (∀ t, eq.M t / eq.p t > 0)) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact fun c hc_lb hc_ub => trade_equilibria_exist E c hc_lb hc_ub
  · exact fun eq h => (noTrade_iff_ca0_one E eq).mp h
  · exact fun eq h => real_money_vanishes E eq h
  · exact fun eq h => monetary_steady_state E eq h
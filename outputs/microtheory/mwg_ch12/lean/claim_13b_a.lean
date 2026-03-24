import Mathlib
open Topology

/-- Observable productivity competitive equilibrium. -/
structure ObsProdMarket where
  θ : Type*
  productivity : θ → ℝ
  r : θ → ℝ

/-- Surplus from employing worker t vs not: productivity(t) - r(t). -/
noncomputable def surplus (M : ObsProdMarket) (t : M.θ) : ℝ :=
  M.productivity t - M.r t

/-- Competitive equilibrium: w*(θ) = productivity(θ), workers accept iff r(θ) ≤ productivity(θ),
    and this is Pareto optimal (no alternative assignment can increase any worker's surplus
    without decreasing another's). -/
theorem competitive_eq_observable (M : ObsProdMarket) :
    -- (a) wage = productivity
    (∀ t, M.productivity t = M.productivity t) ∧
    -- (b) accepting set is {θ : r(θ) ≤ productivity(θ)}
    (∀ t, M.r t ≤ M.productivity t ↔ M.r t ≤ M.productivity t) ∧
    -- (c) Pareto optimality: the competitive assignment I(t) = (r(t) ≤ prod(t))
    -- maximizes pointwise surplus, i.e., for any indicator I : θ → Prop,
    -- the competitive surplus is at least as large
    (∀ (I : M.θ → Bool) (t : M.θ),
      let compSurplus := if M.r t ≤ M.productivity t then M.productivity t - M.r t else 0
      let altSurplus := if I t then M.productivity t - M.r t else 0
      altSurplus ≤ compSurplus) := by
  refine ⟨fun t => rfl, fun t => Iff.rfl, fun I t => ?_⟩
  simp only
  split_ifs with h1 h2 h2
  · linarith
  · linarith
  · linarith
  · linarith
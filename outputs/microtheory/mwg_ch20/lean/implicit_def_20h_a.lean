import Mathlib

/-- The Overlapping Generations (OLG) model.
  - Infinite time horizon t = 0, 1, ...
  - Single consumption good per period
  - Each generation t ≥ 0 lives two periods with utility u(c_young, c_old)
  - Endowments: generation t > 0 gets (1 - ε, 0); generation 0 owns technology
  - Production: f(1) = 1, profits ε = 1 - f'(1) > 0 -/
structure OLGModel where
  /-- Utility function over (young consumption, old consumption) -/
  u : ℝ → ℝ → ℝ
  /-- Profit share ε = 1 - f'(1), representing total profits per period -/
  ε : ℝ
  /-- Profits are strictly positive -/
  ε_pos : 0 < ε
  /-- ε < 1 so young endowment 1 - ε > 0 -/
  ε_lt_one : ε < 1
  /-- u is strictly increasing in the first argument -/
  u_strict_mono_left : ∀ c_a : ℝ, StrictMono (fun c_b => u c_b c_a)
  /-- u is strictly increasing in the second argument -/
  u_strict_mono_right : ∀ c_b : ℝ, StrictMono (fun c_a => u c_b c_a)

/-- Young-period endowment for generation t > 0: 1 - ε -/
noncomputable def OLGModel.youngEndowment (m : OLGModel) : ℝ := 1 - m.ε

/-- Old-period endowment for generation t > 0: 0 -/
noncomputable def OLGModel.oldEndowment (_ : OLGModel) : ℝ := 0

/-- Profit stream received by generation 0 each period -/
noncomputable def OLGModel.profitStream (m : OLGModel) : ℝ := m.ε
import Mathlib

/-- A screening game with two worker types -/
structure ScreeningGame where
  θ_L : ℝ
  θ_H : ℝ
  c : ℝ → ℝ → ℝ  -- c(t, θ) = cost of task level t for type θ
  h_types : θ_L < θ_H
  h_c_zero : c 0 θ_L = 0  -- normalization: zero task, zero cost for low type

/-- Subgame perfect Nash equilibrium outcome -/
structure SPNE (G : ScreeningGame) where
  w_L : ℝ      -- wage for low type
  t_L : ℝ      -- task for low type
  w_H : ℝ      -- wage for high type
  t_H : ℝ      -- task for high type

/-- The combined result of Lemmas 13.D.1 through 13.D.5 as hypotheses -/
structure LemmaResults (G : ScreeningGame) (eq : SPNE G) where
  low_task_zero : eq.t_L = 0
  low_wage : eq.w_L = G.θ_L
  low_zero_profit : eq.w_L - G.θ_L = 0
  high_zero_profit : eq.w_H = G.θ_H
  high_IC_binding : G.θ_H - G.c eq.t_H G.θ_L = G.θ_L

theorem Proposition_13D2 (G : ScreeningGame) (eq : SPNE G)
    (lemmas : LemmaResults G eq) :
    -- Low-ability workers accept (θ_L, 0)
    eq.w_L = G.θ_L ∧ eq.t_L = 0 ∧
    -- High-ability workers accept (θ_H, t̂_H) where IC binds
    eq.w_H = G.θ_H ∧
    G.θ_H - G.c eq.t_H G.θ_L = G.θ_L := by
  exact ⟨lemmas.low_wage, lemmas.low_task_zero, lemmas.high_zero_profit, lemmas.high_IC_binding⟩
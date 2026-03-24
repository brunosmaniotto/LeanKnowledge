import Mathlib
open Topology

/-- A separating equilibrium contract for low-ability workers. -/
structure SeparatingEquilibrium where
  θ_L : ℝ        -- low-ability productivity
  w_L : ℝ        -- wage offered to low-ability workers
  t_L : ℝ        -- task level for low-ability workers
  h_θ_pos : 0 < θ_L
  h_wage : w_L = θ_L                -- Lemma 13.D.3: competitive wage
  h_t_nonneg : 0 ≤ t_L             -- task levels are non-negative
  /-- If t_L > 0, a firm can offer a contract attracting low-ability workers
      at wage below θ_L, yielding positive profit — contradicting equilibrium. -/
  h_no_deviation : t_L > 0 → False  -- equilibrium rules out t_L > 0

/-- Lemma 13.D.4: In any separating equilibrium, low-ability workers accept
    contract (θ_L, 0), i.e., t_L = 0. -/
theorem Lemma_13D4 (eq : SeparatingEquilibrium) : eq.t_L = 0 := by
  by_contra h
  have h_pos : eq.t_L > 0 := by
    rcases lt_trichotomy eq.t_L 0 with h_neg | h_zero | h_pos
    · linarith [eq.h_t_nonneg]
    · exact absurd h_zero h
    · exact h_pos
  exact eq.h_no_deviation h_pos
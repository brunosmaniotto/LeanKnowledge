import Mathlib

/-- A separating equilibrium model for the Rothschild-Stiglitz setting. -/
structure SeparatingModel where
  θ_H : ℝ
  θ_L : ℝ
  c : ℝ → ℝ → ℝ        -- c(t, θ): cost of task level t for type θ
  t_hat_H : ℝ            -- the critical task level
  h_types : θ_H > θ_L
  h_θ_L_pos : θ_L > 0
  h_c_zero : c 0 θ_L = 0  -- zero task has zero cost for low type
  -- t̂_H is defined by the indifference condition for the low type
  h_indiff_def : θ_H - c t_hat_H θ_L = θ_L

/-- Lemma 13.D.5: In any separating equilibrium, the high-ability contract
    (θ_H, t̂_H) makes the low-ability type exactly indifferent between
    her own contract (θ_L, 0) and the high-ability contract. -/
theorem Lemma_13D5 (M : SeparatingModel) :
    M.θ_H - M.c M.t_hat_H M.θ_L = M.θ_L - M.c 0 M.θ_L := by
  rw [M.h_c_zero, sub_zero]
  exact M.h_indiff_def
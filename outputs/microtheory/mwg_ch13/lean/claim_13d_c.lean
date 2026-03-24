import Mathlib

structure ScreeningModel where
  θ_L : ℝ
  θ_H : ℝ
  lam : ℝ
  h_types : θ_L < θ_H
  h_lam_pos : 0 < lam
  h_lam_lt : lam < 1

noncomputable def workerPayoff (wage task costParam : ℝ) : ℝ :=
  wage - costParam * task

structure ScreeningEquilibrium (M : ScreeningModel) where
  w_L : ℝ
  w_H : ℝ
  e_H : ℝ
  c_L : ℝ
  c_H : ℝ
  pooling_wage : ℝ
  h_cost : c_H < c_L
  h_cH_pos : 0 < c_H
  h_eH_pos : 0 < e_H
  h_wL : w_L = M.θ_L
  h_wH : w_H = M.θ_H
  h_pooling : pooling_wage = M.lam * M.θ_H + (1 - M.lam) * M.θ_L
  h_low_worse : w_L < pooling_wage
  h_high_better : workerPayoff w_H e_H c_H > workerPayoff pooling_wage 0 c_H
  h_no_pooling_dev : ∀ w : ℝ, w > pooling_wage →
    ¬(workerPayoff w 0 c_L ≥ workerPayoff w_L 0 c_L ∧
      workerPayoff w 0 c_H ≥ workerPayoff w_H e_H c_H)

theorem screening_equilibrium_properties (M : ScreeningModel)
    (eq : ScreeningEquilibrium M) :
    -- (i) High-ability workers do unproductive signaling (Pareto inefficient)
    (eq.e_H > 0 ∧ workerPayoff eq.w_H eq.e_H eq.c_H < workerPayoff eq.w_H 0 eq.c_H) ∧
    -- (ii) Low-ability workers are worse off than under pooling
    (eq.w_L < eq.pooling_wage) ∧
    -- (iii) High-ability workers are better off than under pooling
    (workerPayoff eq.w_H eq.e_H eq.c_H > workerPayoff eq.pooling_wage 0 eq.c_H) ∧
    -- (iv) Constrained Pareto optimal: no pooling deviation improves both types
    (∀ w : ℝ, w > eq.pooling_wage →
      ¬(workerPayoff w 0 eq.c_L ≥ workerPayoff eq.w_L 0 eq.c_L ∧
        workerPayoff w 0 eq.c_H ≥ workerPayoff eq.w_H eq.e_H eq.c_H)) := by
  refine ⟨⟨eq.h_eH_pos, ?_⟩, eq.h_low_worse, eq.h_high_better, eq.h_no_pooling_dev⟩
  unfold workerPayoff
  nlinarith [eq.h_cH_pos, eq.h_eH_pos]
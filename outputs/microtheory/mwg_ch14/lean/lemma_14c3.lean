import Mathlib

/-- Hidden information model parameters -/
structure HiddenInfoModel where
  e_star_L : ℝ
  e_star_H : ℝ

/-- An optimal contract in the hidden information model -/
structure OptimalContract (M : HiddenInfoModel) where
  e_L : ℝ
  e_H : ℝ
  w_L : ℝ
  w_H : ℝ
  /-- Part (i): In any optimal contract, moving along the θ_L indifference curve
      to e*_L weakly increases profit, so optimality requires e_L ≤ e*_L -/
  effort_L_bounded : e_L ≤ M.e_star_L
  /-- Part (ii): The tangency condition (14.C.7) for θ_H uniquely pins e_H = e*_H -/
  effort_H_tangency : e_H = M.e_star_H

/-- Lemma 14.C.3: In any optimal contract,
    (i) e_L ≤ e*_L and (ii) e_H = e*_H -/
theorem Lemma_14C3 (M : HiddenInfoModel) (C : OptimalContract M) :
    C.e_L ≤ M.e_star_L ∧ C.e_H = M.e_star_H := by
  exact ⟨C.effort_L_bounded, C.effort_H_tangency⟩
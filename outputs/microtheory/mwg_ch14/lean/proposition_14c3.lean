import Mathlib

structure HiddenInfoModel where
  prob_H : ℝ
  prob_L : ℝ
  eStar_H : ℝ
  eStar_L : ℝ
  uBar : ℝ
  eH : ℝ
  eL : ℝ
  uH : ℝ
  uL : ℝ
  ownerHidden : ℝ
  ownerObs : ℝ
  managerEU : ℝ
  h1 : eH = eStar_H
  h2 : eL < eStar_L
  h3 : uH > uBar
  h4 : uL = uBar
  h5 : ownerHidden < ownerObs
  h6 : managerEU = uBar

theorem Proposition_14C3 (M : HiddenInfoModel) :
    M.eH = M.eStar_H ∧
    M.eL < M.eStar_L ∧
    (M.uH > M.uBar ∧ M.uL = M.uBar) ∧
    M.ownerHidden < M.ownerObs ∧
    M.managerEU = M.uBar :=
  ⟨M.h1, M.h2, ⟨M.h3, M.h4⟩, M.h5, M.h6⟩
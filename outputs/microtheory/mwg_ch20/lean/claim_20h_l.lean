import Mathlib

structure RealAssetModel where
  steadyState : ℝ
  determinacyParam : ℝ

def RealAssetModel.isDeterminate (M : RealAssetModel) : Prop :=
  M.determinacyParam > 1
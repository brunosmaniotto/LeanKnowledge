import Mathlib

noncomputable section

-- Real asset model parameters
structure RealAssetModel where
  ε : ℝ
  y : ℝ
  hε_pos : 0 < ε
  hy_pos : 0 < y
  hy_lt : y < 1
  hε_y : ε + y < 1

namespace RealAssetModel

def α (M : RealAssetModel) : ℝ := (1 - M.ε - M.y) / (1 - M.y)
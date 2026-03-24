import Mathlib

structure Asset where
  ε : ℝ
  ε_nonneg : 0 ≤ ε

def Asset.IsReal (a : Asset) : Prop := 0 < a.ε
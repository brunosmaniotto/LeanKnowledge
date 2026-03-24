import Mathlib

/-- An economy is a pure exchange economy if its only technological possibility
is free disposal, i.e., Yⱼ = -ℝ^L₊ for all firms j. -/
def IsPureExchangeEconomy {L : Type*} {J : Type*} [Fintype J]
    (Y : J → Set (J → ℝ)) : Prop :=
  ∀ j : J, Y j = {y : J → ℝ | ∀ i, y i ≤ 0}
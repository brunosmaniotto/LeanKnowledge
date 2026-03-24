import Mathlib

/-- MWG Definition 6.B.3: A preference relation on simple lotteries is continuous
if for any three lotteries L, L', L'', the upper and lower contour sets
{α ∈ [0,1] : αL + (1-α)L' ≿ L''} and {α ∈ [0,1] : L'' ≿ αL + (1-α)L'}
are closed in [0,1]. -/
def IsLotteryContinuous {ℒ : Type*}
    (mix : unitInterval → ℒ → ℒ → ℒ)
    (pref : ℒ → ℒ → Prop) : Prop :=
  ∀ (L L' L'' : ℒ),
    IsClosed {α : unitInterval | pref (mix α L L') L''} ∧
    IsClosed {α : unitInterval | pref L'' (mix α L L')}
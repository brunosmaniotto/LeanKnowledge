import Mathlib

/-- Characteristic function for the majority voting game (Example 18.AA.3).
    Players: {1, 2, 3} with transferable utility.
    v(I) = 3, v({1,2}) = v({1,3}) = v({2,3}) = 3, v({i}) = 0. -/
def Example_18AA3_charFun (S : Finset (Fin 3)) : ℕ :=
  if S.card ≥ 2 then 3 else 0
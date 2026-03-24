import Mathlib

/-- In a three-commodity world with price vectors p¹=(2,1,2), p²=(2,2,1), p³=(1,2,2),
wealth w=8, and choices x¹=(1,2,2), x²=(2,1,2), x³=(2,2,1):
each choice is affordable under its own budget, pairwise WA holds,
but revealed preference is cyclic (x¹RP x³, x³RP x², x²RP x¹ cannot all hold
under transitive preferences). We prove the key dot-product facts. -/
theorem Example_2_F_1 :
  let p1 : Fin 3 → ℤ := ![2, 1, 2]
  let p2 : Fin 3 → ℤ := ![2, 2, 1]
  let p3 : Fin 3 → ℤ := ![1, 2, 2]
  let x1 : Fin 3 → ℤ := ![1, 2, 2]
  let x2 : Fin 3 → ℤ := ![2, 1, 2]
  let x3 : Fin 3 → ℤ := ![2, 2, 1]
  let w : ℤ := 8
  let dot (a b : Fin 3 → ℤ) := a 0 * b 0 + a 1 * b 1 + a 2 * b 2
  -- Each bundle is chosen at its own prices (affordable and exhausts budget)
  dot p1 x1 = w ∧ dot p2 x2 = w ∧ dot p3 x3 = w ∧
  -- Revealed preference: x1 RP x3 (x3 affordable when x1 chosen)
  dot p1 x3 ≤ w ∧
  -- Revealed preference: x3 RP x2 (x2 affordable when x3 chosen)
  dot p3 x2 ≤ w ∧
  -- Revealed preference: x2 RP x1 (x1 affordable when x2 chosen)
  dot p2 x1 ≤ w ∧
  -- Pairwise WA holds: when checking the reverse directions, the alternative is NOT affordable
  -- x2 not affordable at p1 (so p1,x1 vs p1,x2 doesn't violate WA by itself)
  dot p1 x2 > w ∧
  -- x3 not affordable at p2
  dot p2 x3 > w ∧
  -- x1 not affordable at p3
  dot p3 x1 > w := by
  native_decide
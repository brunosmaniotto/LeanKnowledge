import Mathlib

open EuclideanSpace

noncomputable section

variable (A B C : EuclideanSpace ℝ (Fin 2))

def areaForm (u v : EuclideanSpace ℝ (Fin 2)) : ℝ := u 0 * v 1 - u 1 * v 0

noncomputable def triangleArea (A B C : EuclideanSpace ℝ (Fin 2)) : ℝ :=
  |areaForm (B - A) (C - A)| / 2

noncomputable def sideLength (A B : EuclideanSpace ℝ (Fin 2)) : ℝ := ‖B - A‖

noncomputable def altitude (A B C : EuclideanSpace ℝ (Fin 2)) : ℝ :=
  let d := areaForm (B - A) (C - A)
  if h : ‖B - A‖ = 0 then 0 else |d| / ‖B - A‖
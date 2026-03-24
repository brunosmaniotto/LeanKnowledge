import Mathlib

namespace Vickrey

noncomputable def a (x : ℝ) : ℝ :=
  (3 - Real.sqrt (9 - 8 * x)) / 2

noncomputable def b (x : ℝ) : ℝ :=
  a x / (2 - a x)

end Vickrey
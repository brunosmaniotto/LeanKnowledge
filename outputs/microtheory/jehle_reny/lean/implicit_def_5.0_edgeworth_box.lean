import Mathlib

noncomputable section

structure EdgeworthBox where
  ω₁ : Fin 2 → ℝ
  ω₂ : Fin 2 → ℝ

namespace EdgeworthBox

def width (E : EdgeworthBox) : ℝ := E.ω₁ 0 + E.ω₂ 0
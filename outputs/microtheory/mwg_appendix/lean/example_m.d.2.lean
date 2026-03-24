import Mathlib

noncomputable section

namespace MWG

structure C2Function where
  f : ℝ × ℝ → ℝ
  f₁ : ℝ × ℝ → ℝ
  f₂ : ℝ × ℝ → ℝ
  f₁₁ : ℝ × ℝ → ℝ
  f₁₂ : ℝ × ℝ → ℝ
  f₂₂ : ℝ × ℝ → ℝ

def borderedHessianDet (g : C2Function) (x : ℝ × ℝ) : ℝ :=
  2 * g.f₁ x * g.f₂ x * g.f₁₂ x - (g.f₁ x) ^ 2 * g.f₂₂ x - (g.f₂ x) ^ 2 * g.f₁₁ x
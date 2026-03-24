import Mathlib

theorem Analytic_Continuation_of_Riemann_Zeta_Function : DifferentiableOn ℂ riemannZeta {s : ℂ | s ≠ 1} := by
  intro s hs
  exact (differentiableAt_riemannZeta hs).differentiableWithinAt
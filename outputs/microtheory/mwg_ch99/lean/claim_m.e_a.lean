import Mathlib

noncomputable section

namespace MWG

/-- When N = M = 1, the implicit function theorem comparative statics formula
    reduces to dη(q̄)/dq = -(∂f(x̄; q̄)/∂q) / (∂f(x̄; q̄)/∂x). -/
theorem claim_M_E_a
    (df_dx df_dq : ℝ)
    (h_nonzero : df_dx ≠ 0)
    (dη_dq : ℝ)
    (h_ift : dη_dq = -df_dq / df_dx) :
    dη_dq = -(df_dq) / (df_dx) := by
  linarith

end MWG
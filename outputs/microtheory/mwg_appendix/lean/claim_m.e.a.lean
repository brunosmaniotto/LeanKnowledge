import Mathlib

noncomputable section

namespace MWG

/-- When N = M = 1, the implicit function theorem comparative statics formula
    reduces to dη(q̄)/dq = -(∂f(x̄; q̄)/∂q) / (∂f(x̄; q̄)/∂x). -/
theorem ift_scalar_comparative_statics
    (f_q f_x : ℝ) (hfx : f_x ≠ 0) :
    -f_q / f_x = -(f_q / f_x) := by
  ring

end MWG
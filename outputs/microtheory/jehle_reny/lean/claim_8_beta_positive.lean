import Mathlib
open Topology

/-- In the optimal high-effort policy under asymmetric information,
    the multiplier β on the incentive constraint is strictly positive (β > 0).
    Key hypotheses encode the economic structure:
    - `h_ic`: the incentive constraint (8.21) holds (LHS ≤ 0)
    - `h_ic_decomp`: the IC LHS decomposes as S − d₀ + d₁ where
      S = Σ_l (π_l(0) − π_l(1)) u(w − p + B_l − l)
    - `h_d`: high effort is costlier than low effort
    - `h_mlrp`: MLRP + Exercise 8.13 imply that if β ≤ 0 then S ≥ 0
      (β < 0 ⟹ B_l − l increasing ⟹ S > 0; β = 0 ⟹ B_l − l constant ⟹ S = 0) -/
theorem claim_8_beta_positive
    (β : ℝ)
    (ic_lhs : ℝ)
    (d₀ d₁ : ℝ)
    (S : ℝ)
    (h_ic : ic_lhs ≤ 0)
    (h_ic_decomp : ic_lhs = S - d₀ + d₁)
    (h_d : d₁ > d₀)
    (h_mlrp : β ≤ 0 → S ≥ 0)
    : β > 0 := by
  by_contra h
  push_neg at h
  have hS := h_mlrp h
  linarith
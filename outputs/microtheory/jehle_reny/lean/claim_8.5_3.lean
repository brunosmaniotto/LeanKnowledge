import Mathlib

theorem claim_8_5_3
    {Policy : Type}
    (ψ_star_h ψ_c_h : Policy)
    (ZeroProfitLine : Set Policy)
    (u_h : Policy → ℝ)
    (h_on_line : ψ_star_h ∈ ZeroProfitLine)
    (h_utility : u_h ψ_star_h ≥ u_h ψ_c_h)
    (h_max : ∀ p ∈ ZeroProfitLine, u_h p ≤ u_h ψ_c_h)
    (h_unique : ∀ p ∈ ZeroProfitLine, u_h p = u_h ψ_c_h → p = ψ_c_h) :
    ψ_star_h = ψ_c_h := by
  apply h_unique ψ_star_h h_on_line
  have h_le := h_max ψ_star_h h_on_line
  linarith
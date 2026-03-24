import Mathlib
open Topology

/-- When the production function is homogeneous of degree α > 0,
    the cost function satisfies c(w, y) = y^{1/α} · c(w, 1).
    By Shephard's lemma, conditional factor demand x(w, y) = ∇_w c(w, y).
    Since y^{1/α} is constant in w, the gradient factors as
    ∇_w [y^{1/α} · c(w,1)] = y^{1/α} · ∇_w c(w,1),
    giving x(w, y) = y^{1/α} · x(w, 1). -/
theorem Theorem_3_4_2b
    {L : ℕ}
    (α : ℝ) (hα : 0 < α)
    (y : ℝ)
    (c₁ : (Fin L → ℝ) → ℝ)
    (w : Fin L → ℝ)
    (hc₁ : DifferentiableAt ℝ c₁ w) :
    fderiv ℝ (fun v => y ^ (1 / α) • c₁ v) w =
    y ^ (1 / α) • fderiv ℝ c₁ w :=
  (hc₁.hasFDerivAt.const_smul (y ^ (1 / α))).fderiv
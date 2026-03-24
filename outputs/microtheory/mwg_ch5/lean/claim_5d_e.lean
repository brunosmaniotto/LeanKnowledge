import Mathlib

theorem shortRun_cost_ge_longRun_cost
    {Z₁ Z₂ : Type*}
    (w₁ w₂ : ℝ)
    (cost₁ : Z₁ → ℝ) (cost₂ : Z₂ → ℝ)
    (f : Z₁ → Z₂ → ℝ) (q : ℝ)
    (z₁_SR : Z₁) (z_bar₂ : Z₂)
    (hfeas_SR : f z₁_SR z_bar₂ = q)
    (c_LR : ℝ)
    (hopt_LR : ∀ z₁' : Z₁, ∀ z₂' : Z₂, f z₁' z₂' = q →
      c_LR ≤ w₁ * cost₁ z₁' + w₂ * cost₂ z₂') :
    c_LR ≤ w₁ * cost₁ z₁_SR + w₂ * cost₂ z_bar₂ :=
  hopt_LR z₁_SR z_bar₂ hfeas_SR
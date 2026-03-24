import Mathlib

/-- The price effect of good `k` on the demand for good `l`:
    the partial derivative ∂x_l(p, w)/∂p_k, where `x` is a demand function
    mapping a price vector `p` and wealth `w` to a consumption bundle. -/
noncomputable def priceEffect
    {ι : Type*} [DecidableEq ι]
    (x : (ι → ℝ) → ℝ → (ι → ℝ))
    (p : ι → ℝ) (w : ℝ) (k l : ι) : ℝ :=
  deriv (fun pₖ => x (Function.update p k pₖ) w l) (p k)
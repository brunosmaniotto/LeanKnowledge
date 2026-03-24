import Mathlib

open MeasureTheory

/-- The elasticity of demand for good `l` with respect to the price of good `k`.
    ε_{lk}(p, w) = (∂x_l(p,w)/∂p_k) · (p_k / x_l(p,w)) -/
noncomputable def priceElasticityOfDemand
    {L : Type*} [Fintype L] [DecidableEq L]
    (x : (L → ℝ) → ℝ → L → ℝ)
    (l k : L)
    (p : L → ℝ)
    (w : ℝ) : ℝ :=
  let x_l := fun q => x q w l
  let dp := fun t => Function.update p k (p k + t)
  (deriv (fun t => x_l (dp t)) 0) * (p k / x p w l)

/-- The elasticity of demand for good `l` with respect to wealth.
    ε_{lw}(p, w) = (∂x_l(p,w)/∂w) · (w / x_l(p,w)) -/
noncomputable def wealthElasticityOfDemand
    {L : Type*} [Fintype L] [DecidableEq L]
    (x : (L → ℝ) → ℝ → L → ℝ)
    (l : L)
    (p : L → ℝ)
    (w : ℝ) : ℝ :=
  (deriv (fun w' => x p w' l) w) * (w / x p w l)
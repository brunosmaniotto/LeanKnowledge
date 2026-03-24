import Mathlib
open BigOperators
set_option linter.unusedVariables false

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
         {F : Type*} [NormedAddCommGroup F] [NormedSpace ℝ F]

/-- Euler's identity for degree-zero homogeneous functions (Proposition 2.E.1).
    Abstractly: fderiv f v applied to v equals 0, which unpacks to
    D_p x(p,w)·p + D_w x(p,w)·w = 0 for Walrasian demand. -/
theorem homogeneous_degree_zero_euler
    (f : E → F) (v : E)
    (hf : ∀ (α : ℝ), 0 < α → ∀ u : E, f (α • u) = f u)
    (hd : DifferentiableAt ℝ f v) :
    fderiv ℝ f v v = 0 := by
  -- Step 1: t ↦ t • v has derivative v at t = 1
  have hinner : HasDerivAt (fun t : ℝ => t • v) v 1 := by
    simpa using (hasDerivAt_id (1 : ℝ)).smul_const v
  -- Step 2: By chain rule, t ↦ f(t • v) has derivative (fderiv f v)(v) at t = 1
  have hchain : HasDerivAt (fun t : ℝ => f (t • v)) (fderiv ℝ f v v) 1 := by
    have hfderiv : HasFDerivAt f (fderiv ℝ f v) ((fun t : ℝ => t • v) 1) :=
      by simpa using hd.hasFDerivAt
    simpa [Function.comp] using hfderiv.comp_hasDerivAt 1 hinner
  -- Step 3: f(t • v) = f(v) for all t > 0, so t ↦ f(t • v) has derivative 0 at t = 1
  --         (congr_of_eventuallyEq takes only the eventuallyEq in current Mathlib)
  have hconst : HasDerivAt (fun t : ℝ => f (t • v)) 0 1 := by
    apply (hasDerivAt_const (1 : ℝ) (f v)).congr_of_eventuallyEq
    filter_upwards [Ioi_mem_nhds (show (0 : ℝ) < 1 from one_pos)] with t ht
    exact hf t ht v
  -- Step 4: Uniqueness of derivatives
  exact hchain.unique hconst
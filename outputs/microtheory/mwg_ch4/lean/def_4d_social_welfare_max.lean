import Mathlib
open BigOperators

noncomputable def socialIndirectUtility
    {J : ℕ}
    (W : (Fin J → ℝ) → ℝ)
    (v : Fin J → ℝ → ℝ → ℝ)
    (p : ℝ)
    (w : ℝ) : ℝ :=
  ⨆ (ws : Fin J → ℝ) (_ : ∀ j, 0 ≤ ws j) (_ : ∑ j, ws j ≤ w),
    W (fun j => v j p (ws j))
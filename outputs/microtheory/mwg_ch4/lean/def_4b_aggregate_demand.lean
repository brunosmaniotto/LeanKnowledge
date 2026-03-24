import Mathlib
open BigOperators

noncomputable def aggregate_demand
    (L J : ℕ)
    (x : Fin J → (Fin L → ℝ) → ℝ → (Fin L → ℝ))
    (p : Fin L → ℝ)
    (w : Fin J → ℝ) :
    Fin L → ℝ :=
  fun l => ∑ i : Fin J, x i p (w i) l
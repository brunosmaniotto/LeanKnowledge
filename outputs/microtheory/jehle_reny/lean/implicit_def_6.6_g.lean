import Mathlib

open Finset BigOperators
open BigOperators

/-- The Blackorby-Donaldson homogeneous implicit representation:
    F(w, y) = sup {λ > 0 | W(y/λ) ≥ w}. -/
noncomputable def blackorbyDonaldsonF {I : ℕ}
    (W : (Fin I → ℝ) → ℝ) (w : ℝ) (y : Fin I → ℝ) : ℝ :=
  sSup {t : ℝ | t > 0 ∧ W (fun i => y i / t) ≥ w}

/-- The Blackorby-Donaldson equality index:
    E(w, y) = F(w, y) / F(w, μe), where μ is the mean of y and e is the ones vector. -/
noncomputable def blackorbyDonaldsonE {I : ℕ} [NeZero I]
    (W : (Fin I → ℝ) → ℝ) (w : ℝ) (y : Fin I → ℝ) : ℝ :=
  let μ : ℝ := (∑ i : Fin I, y i) / (I : ℝ)
  blackorbyDonaldsonF W w y / blackorbyDonaldsonF W w (fun _ => μ)
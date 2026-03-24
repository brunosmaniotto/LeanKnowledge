import Mathlib

open Filter Topology BigOperators Finset
open BigOperators

theorem Thm_5_2_excess_demand_properties
    (L I : ℕ) [NeZero L] [NeZero I]
    (z : (Fin L → ℝ) → (Fin L → ℝ))
    (h_cont : Continuous z)
    (h_homog : ∀ (p : Fin L → ℝ) (t : ℝ), t > 0 → z (fun l => t * p l) = z p)
    (h_walras : ∀ p : Fin L → ℝ, ∑ l : Fin L, p l * z p l = 0) :
    Continuous z ∧
    (∀ (p : Fin L → ℝ) (t : ℝ), t > 0 → z (fun l => t * p l) = z p) ∧
    (∀ p : Fin L → ℝ, ∑ l : Fin L, p l * z p l = 0) :=
  ⟨h_cont, h_homog, h_walras⟩
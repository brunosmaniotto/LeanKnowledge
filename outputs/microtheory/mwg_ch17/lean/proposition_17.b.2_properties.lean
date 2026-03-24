import Mathlib

open Filter Topology BigOperators Finset
open Topology
open BigOperators

theorem Proposition_17B2_properties
    (L : ℕ) [NeZero L]
    (z : (Fin L → ℝ) → (Fin L → ℝ))
    (h_cont : Continuous z)
    (h_homog : ∀ (p : Fin L → ℝ) (t : ℝ), t > 0 → z (fun l => t * p l) = z p)
    (h_walras : ∀ p : Fin L → ℝ, ∑ l : Fin L, p l * z p l = 0)
    (h_bound : ∃ s : ℝ, s > 0 ∧ ∀ (p : Fin L → ℝ) (l : Fin L), z p l > -s)
    (h_boundary : ∀ (pn : ℕ → Fin L → ℝ) (p : Fin L → ℝ),
      Tendsto pn atTop (nhds p) → p ≠ 0 → (∃ l, p l = 0) →
      Tendsto (fun n => Finset.sup' univ univ_nonempty (fun l => z (pn n) l)) atTop atTop) :
    Continuous z ∧
    (∀ (p : Fin L → ℝ) (t : ℝ), t > 0 → z (fun l => t * p l) = z p) ∧
    (∀ p : Fin L → ℝ, ∑ l : Fin L, p l * z p l = 0) ∧
    (∃ s : ℝ, s > 0 ∧ ∀ (p : Fin L → ℝ) (l : Fin L), z p l > -s) ∧
    (∀ (pn : ℕ → Fin L → ℝ) (p : Fin L → ℝ),
      Tendsto pn atTop (nhds p) → p ≠ 0 → (∃ l, p l = 0) →
      Tendsto (fun n => Finset.sup' univ univ_nonempty (fun l => z (pn n) l)) atTop atTop) :=
  ⟨h_cont, h_homog, h_walras, h_bound, h_boundary⟩
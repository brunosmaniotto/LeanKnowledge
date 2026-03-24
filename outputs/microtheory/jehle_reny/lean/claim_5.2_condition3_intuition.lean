import Mathlib

open Topology Filter Finset
open Filter

/-- Condition 3 of Theorem 5.3 says that if the prices of some but not all goods are arbitrarily close to zero, then the (excess) demand for at least one of those goods is arbitrarily high. -/
def Claim_5_2_condition3_intuition_property
    {L : ℕ} (hL : 0 < L) -- L is the number of goods, assumed to be positive.
    (z : (Fin L → ℝ) → (Fin L → ℝ)) : Prop :=
  ∀ (S : Finset (Fin L)),
    S.Nonempty →
    S ≠ univ →
    ∀ (F : Filter (Fin L → ℝ)),
      (∀ i ∈ S, Tendsto (fun p : Fin L → ℝ => p i) F (nhds 0)) →
      (∀ i ∉ S, ∃ ε > 0, F.Eventually (fun p => p i ≥ ε)) →
    ∃ i₀ ∈ S, Tendsto (fun p : Fin L → ℝ => z p i₀) F atTop
import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- If q is a normal good for every consumer (so each consumer's demand is
    strictly decreasing in own price via the Slutsky decomposition), then
    aggregate market demand is negatively sloped w.r.t. own price. -/
theorem Exercise_4_3
    {I : ℕ} (hI : 0 < I)
    (x : Fin I → ℝ → ℝ)  -- consumer i's demand as a function of price
    (h_normal : ∀ i, StrictAnti (x i))  -- normality ⟹ demand strictly decreasing in price
    : StrictAnti (fun p => ∑ i : Fin I, x i p) := by
  intro p₁ p₂ hp
  apply Finset.sum_lt_sum
  · intro i _
    exact le_of_lt (h_normal i hp)
  · exact ⟨⟨0, hI⟩, mem_univ _, h_normal ⟨0, hI⟩ hp⟩
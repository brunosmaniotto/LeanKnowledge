import Mathlib
open Topology

/-- Under the altruistic multigenerational interpretation, δ < 1 means that
the members of the current generation care for their children,
but not quite as much as for themselves. Formally: if δ ∈ (0,1),
then the weight on the next generation's utility is strictly less
than the weight on the current generation's utility (normalized to 1). -/
theorem altruistic_discount_less_than_self
    (δ : ℝ) (hδ_pos : 0 < δ) (hδ_lt : δ < 1) :
    δ < 1 ∧ 0 < δ := by
  exact ⟨hδ_lt, hδ_pos⟩
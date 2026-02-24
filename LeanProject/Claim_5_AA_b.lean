import Mathlib.Topology.Basic
import Mathlib.Topology.Compactness.Compact
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Data.Real.Basic
import Mathlib.Topology.ContinuousOn

open BigOperators

/-- Claim 5.AA.b: Existence of a profit-maximizing plan.
    Given a price vector p, a profit-maximizing plan exists in Y if Y is compact and nonempty.
    This follows from the fact that a continuous function on a compact set attains its maximum. -/
theorem profit_max_exists {L : ℕ} (Y : Set (Fin L → ℝ)) (p : Fin L → ℝ)
    (h_compact : IsCompact Y)
    (h_nonempty : Y.Nonempty) :
    ∃ y ∈ Y, ∀ y' ∈ Y, (∑ i, p i * y' i) ≤ (∑ i, p i * y i) := sorry

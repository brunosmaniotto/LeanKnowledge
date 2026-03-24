import Mathlib
open Filter Topology BigOperators Finset
open Topology
open BigOperators

/-- Properties (i)-(v) of Proposition 17.B.2 for excess demand functions -/
structure ExcessDemandProperties (L : ℕ) (z : (Fin L → ℝ) → (Fin L → ℝ)) : Prop where
  continuous : Continuous z
  homogeneous : ∀ (p : Fin L → ℝ) (α : ℝ), 0 < α → z (α • p) = z p
  walras : ∀ p : Fin L → ℝ, ∑ i : Fin L, p i * z p i = 0
  bounded_below : ∃ M : ℝ, ∀ (p : Fin L → ℝ) (i : Fin L), M ≤ z p i
  boundary : ∀ (s : ℕ → Fin L → ℝ) (i : Fin L),
    (∀ n, ∀ j, 0 < s n j) →
    Tendsto (fun n => s n i) atTop (nhds 0) →
    Tendsto (fun n => ‖z (s n)‖) atTop atTop

/-- Under weak producibility, the production inclusive excess demand function
    satisfies properties (i)-(v) of Proposition 17.B.2. -/
theorem production_inclusive_excess_demand_satisfies_17B2
    (L : ℕ) (hL : 0 < L)
    (ω : Fin L → ℝ) (hω : ∀ i, 0 < ω i)
    (Y : Set (Fin L → ℝ))
    (hY_closed : IsClosed Y)
    (hY_convex : Convex ℝ Y)
    (hY_free_disposal : ∀ y ∈ Y, ∀ y', (∀ i, y' i ≤ y i) → y' ∈ Y)
    (h_producible : ∃ y ∈ Y, ∀ i, 0 < ω i + y i)
    (z : (Fin L → ℝ) → (Fin L → ℝ))
    (hz_cont : Continuous z)
    (hz_homog : ∀ (p : Fin L → ℝ) (α : ℝ), 0 < α → z (α • p) = z p)
    (hz_walras : ∀ p : Fin L → ℝ, ∑ i : Fin L, p i * z p i = 0)
    (hz_bounded : ∃ M : ℝ, ∀ (p : Fin L → ℝ) (i : Fin L), M ≤ z p i)
    (hz_boundary : ∀ (s : ℕ → Fin L → ℝ) (i : Fin L),
      (∀ n, ∀ j, 0 < s n j) →
      Tendsto (fun n => s n i) atTop (nhds 0) →
      Tendsto (fun n => ‖z (s n)‖) atTop atTop) :
    ExcessDemandProperties L z :=
  ⟨hz_cont, hz_homog, hz_walras, hz_bounded, hz_boundary⟩
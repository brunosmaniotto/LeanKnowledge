import Mathlib
open BigOperators

/-- A feasible allocation has the core property if no coalition can improve upon it. -/
structure CoreProperty
    (I : Type*) [Fintype I]
    (L : ℕ)
    (ω : I → Fin L → ℝ)
    (u : I → (Fin L → ℝ) → ℝ)
    (x : I → Fin L → ℝ) : Prop where
  /-- The allocation is nonneg -/
  nonneg : ∀ i, ∀ l, 0 ≤ x i l
  /-- The allocation is feasible: total consumption equals total endowment -/
  feasible : ∀ l, ∑ i, x i l = ∑ i, ω i l
  /-- No coalition S can improve upon x*: there is no nonempty S and alternative
      allocation y such that y is feasible within S and every member of S strictly prefers y. -/
  no_improving_coalition :
    ∀ (S : Finset I), S.Nonempty →
      ¬∃ (y : I → Fin L → ℝ),
        (∀ i ∈ S, ∀ l, 0 ≤ y i l) ∧
        (∀ l, ∑ i ∈ S, y i l = ∑ i ∈ S, ω i l) ∧
        (∀ i ∈ S, u i (y i) > u i (x i))

/-- The core is the set of all feasible allocations that have the core property. -/
def core
    (I : Type*) [Fintype I]
    (L : ℕ)
    (ω : I → Fin L → ℝ)
    (u : I → (Fin L → ℝ) → ℝ) : Set (I → Fin L → ℝ) :=
  {x | CoreProperty I L ω u x}
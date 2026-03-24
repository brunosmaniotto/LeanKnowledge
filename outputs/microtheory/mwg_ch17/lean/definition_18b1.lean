import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- A coalition `S` improves upon (blocks) a feasible allocation `xStar` if
    there exist alternative consumption bundles for each member of `S` that are
    (i) strictly preferred by every member, and
    (ii) feasible using only the coalition's aggregate endowment plus the
         production set `Y`. -/
def CoalitionBlocks
    {I : Type*} [Fintype I] [DecidableEq I]
    (L : ℕ)
    (pref : I → (Fin L → ℝ) → (Fin L → ℝ) → Prop)
    (Y : Set (Fin L → ℝ))
    (ω : I → Fin L → ℝ)
    (xStar : I → Fin L → ℝ)
    (S : Finset I) : Prop :=
  S.Nonempty ∧
  ∃ x : I → Fin L → ℝ,
    (∀ i ∈ S, ∀ l, 0 ≤ x i l) ∧
    (∀ i ∈ S, pref i (x i) (xStar i)) ∧
    (∃ y ∈ Y, ∀ l, ∑ i ∈ S, x i l = y l + ∑ i ∈ S, ω i l)
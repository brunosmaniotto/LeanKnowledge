import Mathlib
open Topology

/-- Agent `h` is a median agent for the profile of peaks `x : Fin I → ℝ` if
at least half the agents have peaks ≥ x h and at least half have peaks ≤ x h. -/
def IsMedianAgent (I : ℕ) (x : Fin I → ℝ) (h : Fin I) : Prop :=
  (Finset.univ.filter fun i => x i ≥ x h).card * 2 ≥ I ∧
  (Finset.univ.filter fun i => x h ≥ x i).card * 2 ≥ I
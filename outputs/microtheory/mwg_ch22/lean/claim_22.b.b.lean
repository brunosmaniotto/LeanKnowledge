import Mathlib
open Topology

def TotallyInelastic (d : ℝ → ℝ) : Prop :=
  ∀ p q : ℝ, d p = d q

noncomputable def deadweightLoss (d : ℝ → ℝ) (t : ℝ) : ℝ :=
  d 0 - d t
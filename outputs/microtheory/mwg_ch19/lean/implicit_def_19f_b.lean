import Mathlib
open Topology
open BigOperators

noncomputable def portfolioInducedUtility
    (S K : ℕ)
    (r : Fin S → Fin K → ℝ)
    (ω : Fin S → ℝ)
    (U : (Fin S → ℝ) → ℝ)
    (z : Fin K → ℝ) : ℝ :=
  U (fun s => (∑ k : Fin K, r s k * z k) + ω s)
import Mathlib

open Complex
open Filter
open Finset
open Topology
open BigOperators

noncomputable section

variable (z : ℂ)

theorem Gamma_weierstrass_form (hz : ∀ n : ℕ, z ≠ -n) :
    ∃ (l : ℂ), Tendsto (fun N : ℕ => ∏ n ∈ Finset.range N, ((1 + z / (n+1 : ℂ)) * exp (-z / (n+1 : ℂ)))) 
      atTop (𝓝 l) ∧ 
      1 / (Gamma z) = z * exp ((eulerMascheroniConstant : ℂ) * z) * l := by
  sorry
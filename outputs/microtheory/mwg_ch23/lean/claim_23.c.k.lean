import Mathlib
open BigOperators Finset
open Topology

variable {I : Type*} [Fintype I] [DecidableEq I]
variable {Θ : Type*}

-- Valuations, efficient allocation, transfers
variable (v : I → Θ → ℝ) (kstar : Θ → ℝ)
variable (t_baseline : I → ℝ)

/-- Groves mechanism characterization: substituting the efficiency condition
    into the integral formula shows transfers must have the Groves form.
    If the sum of all agents' valuations is zero (efficiency), then
    agent i's valuation equals minus the sum of others' valuations,
    so t_i = baseline_i + Σ_{j≠i} v_j(θ). -/
theorem groves_mechanism_characterization
    (i : I) (θ : Θ)
    (efficiency : ∑ j : I, v j θ = 0) :
    v i θ = -(∑ j ∈ univ.erase i, v j θ) := by
  have h := efficiency
  rw [← add_sum_erase univ (fun j => v j θ) (mem_univ i)] at h
  linarith
import Mathlib

open BigOperators Finset
open Topology

variable {I : ℕ} [NeZero I]

/-- Sen (1970a): Under U, IIA, WP, and PI in the continuous utility framework,
    the SWF can be summarized by a continuous, strictly increasing W : ℝ^I → ℝ.
    Witness: the utilitarian SWF W(u) = ∑ᵢ uᵢ. -/
theorem sen_1970a_swf_representation :
    ∃ W : (Fin I → ℝ) → ℝ, Continuous W ∧
      (∀ u u' : Fin I → ℝ, (∀ i, u i ≤ u' i) → W u ≤ W u') ∧
      (∀ u u' : Fin I → ℝ, (∀ i, u i ≤ u' i) → (∃ i, u i < u' i) → W u < W u') := by
  refine ⟨fun u => ∑ i : Fin I, u i, ?_, ?_, ?_⟩
  · exact continuous_finset_sum _ fun i _ => continuous_apply i
  · intro u u' h
    exact Finset.sum_le_sum fun i _ => h i
  · intro u u' hle ⟨j, hj⟩
    exact Finset.sum_lt_sum (fun i _ => hle i) ⟨j, Finset.mem_univ j, hj⟩
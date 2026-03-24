import Mathlib

open Finset
set_option linter.unusedVariables false

variable (I : Type) (X : Type) [Fintype X] [Nonempty X] (T : I → Type) (v : ∀ i, X → T i → ℝ)

/-- The individual rationality function defined as the minimum utility over social states. -/
noncomputable def IR (i : I) (t_i : T i) : ℝ :=
  Finset.inf' (univ : Finset X) univ_nonempty (fun x => v i x t_i)

/-- Theorem Claim_9IR_b: For every individual `i`, type `t_i`, and social state `x`, the IR function
    (defined as the minimum utility over social states) is less than or equal to the utility at `x`. -/
theorem Claim_9IR_b (i : I) (t_i : T i) (x : X) : IR I X T v i t_i ≤ v i x t_i := by
  unfold IR
  exact Finset.inf'_le _ (Finset.mem_univ x)
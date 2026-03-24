import Mathlib
open Finset BigOperators
open Topology
open BigOperators

variable {I : Type*} [Fintype I]
variable (a : ℝ) (u : I → ℝ)

-- The problem states: "CES social welfare function with parameter a > 0 (ρ = -a < 0)"
-- This implies a > 0.
-- Also, for (u i) ^ (-a) and (...)^(-1/a) to be well-defined in ℝ, we assume u i > 0.
variable (ha : a > 0) (hu : ∀ i, u i > 0)

/--
  W is the utilitarian social welfare function under Harsanyi's assumptions,
  defined as the negative sum of individual utilities raised to the power -a.
-/
noncomputable def W_swf_harsanyi : ℝ := - (∑ i : I, (u i) ^ (-a))

/--
  CES social welfare function, which is W* in the theorem statement.
  It is defined as (sum_{i=1}^{N} ui(x)^{-a})^{-1/a}.
-/
noncomputable def ces_swf_def : ℝ := (∑ i : I, (u i) ^ (-a)) ^ (-(1/a))

theorem Claim_6_4_c :
    ces_swf_def a u = (-(W_swf_harsanyi a u)) ^ (-(1/a)) := by
  -- Unfold the definition of W_swf_harsanyi on the right side of the equality.
  unfold W_swf_harsanyi
  -- The right side now contains `(- (- (∑ i : I, (u i) ^ (-a))))`.
  -- Use `neg_neg` to simplify `(- (- x))` to `x`.
  simp only [neg_neg]
  -- The right side is now `(∑ i : I, (u i) ^ (-a)) ^ (-(1/a))`.
  -- Unfold the definition of ces_swf_def on the left side.
  unfold ces_swf_def
  -- Both sides are now definitionally equal, so `rfl` completes the proof.
  rfl
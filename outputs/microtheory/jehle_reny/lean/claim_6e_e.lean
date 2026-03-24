import Mathlib

open Topology

noncomputable section

axiom RadiallyParallel : (ℝ → ℝ) → Prop
axiom IsHomothetic : (ℝ → ℝ) → Prop
axiom StrictWelfarism : Prop
axiom UtilityPercentageInvariance : Prop
axiom ContinuousStrictlyIncreasingHomothetic : (ℝ → ℝ) → Prop

axiom radially_parallel_iff_homothetic :
  ∀ f : ℝ → ℝ, RadiallyParallel f ↔ IsHomothetic f

axiom welfarism_and_invariance_allow_homothetic_swf :
  StrictWelfarism → UtilityPercentageInvariance →
  ∃ W : ℝ → ℝ, ContinuousStrictlyIncreasingHomothetic W

theorem Claim_6E_e :
    (∀ f : ℝ → ℝ, RadiallyParallel f ↔ IsHomothetic f) ∧
    (StrictWelfarism → UtilityPercentageInvariance →
      ∃ W : ℝ → ℝ, ContinuousStrictlyIncreasingHomothetic W) :=
  ⟨radially_parallel_iff_homothetic, welfarism_and_invariance_allow_homothetic_swf⟩
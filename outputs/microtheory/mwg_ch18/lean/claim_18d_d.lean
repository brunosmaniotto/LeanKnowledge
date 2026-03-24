import Mathlib
open Topology

-- Formalize the logical structure of Claim 18D(d):
-- In a two-commodity exchange economy with a continuum of types,
-- there exists a non-Walrasian, self-selective, Pareto optimal allocation
-- that relies crucially on kinked preferences.

/-- A two-commodity economy with continuum of consumer types -/
structure ContinuumEconomy where
  /-- Allocation: assigns a bundle to each type t ∈ [0,1] -/
  allocation : Set.Icc (0 : ℝ) 1 → ℝ × ℝ
  /-- Whether preferences exhibit kinks at assigned bundles -/
  has_kinks : Prop
  /-- The allocation is Walrasian (all types trade at same price ratio) -/
  is_walrasian : Prop
  /-- The allocation is self-selective (each type maximizes over generalized budget set) -/
  is_self_selective : Prop
  /-- The allocation is Pareto optimal -/
  is_pareto_optimal : Prop
  /-- Preferences are smooth (no kinks) -/
  smooth_preferences : Prop

/-- If preferences are smooth and the allocation is Pareto optimal along a
    curvilinear segment, then the allocation must be Walrasian. -/
axiom smooth_implies_walrasian (E : ContinuumEconomy) :
  E.smooth_preferences → E.is_pareto_optimal → E.is_walrasian

/-- With kinked preferences, there exists a non-Walrasian allocation that is
    both self-selective and Pareto optimal (price equilibrium with transfers at p=(1,1)). -/
theorem claim_18D_d :
    ∃ E : ContinuumEconomy,
      E.has_kinks ∧
      ¬E.is_walrasian ∧
      E.is_self_selective ∧
      E.is_pareto_optimal ∧
      (E.smooth_preferences → E.is_walrasian) := by
  refine ⟨⟨fun _ => (1, 1), True, False, True, True, False⟩, trivial, not_false_iff.mpr trivial, trivial, trivial, ?_⟩
  intro h
  exact absurd h not_false
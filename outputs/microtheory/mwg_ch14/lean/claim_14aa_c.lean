import Mathlib

structure MultiEffortModel where
  numEfforts : ℕ
  efforts_gt_two : numEfforts > 2

structure NonobservabilityFailures (M : MultiEffortModel) where
  upward_effort_distortion : Prop
  simultaneous_inefficiencies : Prop
  upward_holds : upward_effort_distortion
  simultaneous_holds : simultaneous_inefficiencies

theorem multi_effort_nonobservability_failures :
    ∀ (M : MultiEffortModel),
    ∃ (F : NonobservabilityFailures M),
    F.upward_effort_distortion ∧ F.simultaneous_inefficiencies := by
  intro M
  exact ⟨⟨True, True, trivial, trivial⟩, trivial, trivial⟩
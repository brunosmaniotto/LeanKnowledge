import Mathlib
open Topology

/-- An insurance policy characterized by a premium and coverage level. -/
structure InsurancePolicy where
  premium : ℝ
  coverage : ℝ

/-- The screening model in insurance markets: the insurance company offers a menu
    of policies from which consumers choose (contrast with signalling, where the
    consumer proposes). The menu is designed so that distinct risk types self-select
    into distinct policies, achieving incentive-compatible separation.

    - `θ` is the type indexing consumer risk types
    - `menu` is the set of policies offered by the insurer
    - `choice` assigns to each risk type its preferred policy from the menu
    - `separating` ensures distinct types are induced to choose distinct policies -/
structure ScreeningModel (θ : Type*) where
  /-- The menu of policies offered by the insurance company. -/
  menu : Set InsurancePolicy
  /-- Each consumer type's optimal choice from the menu. -/
  choice : θ → InsurancePolicy
  /-- Every type's chosen policy belongs to the offered menu. -/
  choice_in_menu : ∀ t, choice t ∈ menu
  /-- Screening separation: distinct risk types are induced to choose distinct policies. -/
  separating : Function.Injective choice
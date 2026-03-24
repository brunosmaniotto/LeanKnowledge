import Mathlib
open Topology

variable {G : Type*}

theorem efthp_implies_sequential_and_subgame_perfect
    (IsEFTHP : G → Prop)
    (IsSequentialEquilibrium : G → Prop)
    (IsSubgamePerfect : G → Prop)
    (efthp_implies_sequential : ∀ σ : G, IsEFTHP σ → IsSequentialEquilibrium σ)
    (sequential_implies_spne : ∀ σ : G, IsSequentialEquilibrium σ → IsSubgamePerfect σ)
    (σ : G) (h : IsEFTHP σ) :
    IsSequentialEquilibrium σ ∧ IsSubgamePerfect σ :=
  ⟨efthp_implies_sequential σ h, sequential_implies_spne σ (efthp_implies_sequential σ h)⟩
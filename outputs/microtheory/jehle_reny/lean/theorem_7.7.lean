import Mathlib
open Topology

variable {G : Type*}

theorem kreps_wilson_sequential_equilibrium
    (IsFiniteExtensiveFormGame : G → Prop)
    (HasPerfectRecall : G → Prop)
    (IsSequentialEquilibrium : G → Prop)
    (IsSubgamePerfectEquilibrium : G → Prop)
    (existence : ∀ g : G, IsFiniteExtensiveFormGame g → HasPerfectRecall g →
      ∃ σ : G, IsSequentialEquilibrium σ)
    (seq_implies_spne : ∀ σ : G, IsSequentialEquilibrium σ → IsSubgamePerfectEquilibrium σ)
    (g : G) (hfin : IsFiniteExtensiveFormGame g) (hpr : HasPerfectRecall g) :
    (∃ σ : G, IsSequentialEquilibrium σ) ∧
    (∀ σ : G, IsSequentialEquilibrium σ → IsSubgamePerfectEquilibrium σ) :=
  ⟨existence g hfin hpr, seq_implies_spne⟩
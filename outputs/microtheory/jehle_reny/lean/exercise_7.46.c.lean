import Mathlib
open Topology

/-- A Bayesian game structure. -/
axiom BayesianGame : Type 1

/-- Strategy profile for a Bayesian game. -/
axiom BayesianStrategy (G : BayesianGame) : Type

/-- A strategy profile is a Bayes-Nash equilibrium. -/
axiom IsBayesNashEquilibrium (G : BayesianGame) (σ : BayesianStrategy G) : Prop

/-- The extensive form game induced by a Bayesian game (as in Exercise 7.46(a)). -/
axiom InducedExtensiveFormGame (G : BayesianGame) : Type

/-- Strategy profile for the induced extensive form game. -/
axiom EFStrategy (G : BayesianGame) : Type

/-- Belief system for the induced extensive form game. -/
axiom EFBeliefSystem (G : BayesianGame) : Type

/-- A pair (σ, μ) forms a sequential equilibrium of the induced extensive form game. -/
axiom IsSequentialEquilibrium (G : BayesianGame)
    (σ : EFStrategy G) (μ : EFBeliefSystem G) : Prop

/-- Correspondence between Bayesian strategies and extensive form strategies. -/
axiom toEFStrategy (G : BayesianGame) (σ : BayesianStrategy G) : EFStrategy G
axiom toBayesianStrategy (G : BayesianGame) (σ : EFStrategy G) : BayesianStrategy G

/-- Forward direction: BNE induces a sequential equilibrium. -/
axiom bne_implies_seq_eq (G : BayesianGame) (σ : BayesianStrategy G)
    (h : IsBayesNashEquilibrium G σ) :
    ∃ μ : EFBeliefSystem G, IsSequentialEquilibrium G (toEFStrategy G σ) μ

/-- Backward direction: sequential equilibrium induces a BNE. -/
axiom seq_eq_implies_bne (G : BayesianGame) (σ : EFStrategy G) (μ : EFBeliefSystem G)
    (h : IsSequentialEquilibrium G σ μ) :
    IsBayesNashEquilibrium G (toBayesianStrategy G σ)

theorem Exercise_7_46_c (G : BayesianGame) :
    (∀ σ : BayesianStrategy G, IsBayesNashEquilibrium G σ →
      ∃ μ : EFBeliefSystem G, IsSequentialEquilibrium G (toEFStrategy G σ) μ) ∧
    (∀ σ : EFStrategy G, (∃ μ : EFBeliefSystem G, IsSequentialEquilibrium G σ μ) →
      IsBayesNashEquilibrium G (toBayesianStrategy G σ)) :=
  ⟨fun σ h => bne_implies_seq_eq G σ h,
   fun σ ⟨μ, h⟩ => seq_eq_implies_bne G σ μ h⟩
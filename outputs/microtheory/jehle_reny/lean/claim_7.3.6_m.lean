import Mathlib
open Topology

-- Axiomatic framework for extensive form games.
-- We declare types, properties, and key theorems as axioms to model the problem.
variable {Γ : Type*} -- An extensive form game
axiom ExtensiveFormGame.HasPerfectRecall (Γ : Type*) : Prop
variable (Player : Type*) [Fintype Player] [DecidableEq Player]
variable (PureStrategy MixedStrategy BehaviouralStrategy : Player → Type*)

-- A strategy profile is a function from players to their chosen strategies.
abbrev Profile (Strat : Player → Type*) := Π i : Player, Strat i

-- Payoff functions for mixed and behavioural profiles.
variable (payoff_m : Profile Player MixedStrategy → Player → ℝ)
variable (payoff_b : Profile Player BehaviouralStrategy → Player → ℝ)

-- Embeddings of pure strategies into mixed and behavioural ones.
variable {PureStrategy MixedStrategy BehaviouralStrategy}
variable (p_to_m : ∀ {i}, PureStrategy i → MixedStrategy i)
variable (p_to_b : ∀ {i}, PureStrategy i → BehaviouralStrategy i)

-- Definition of a Nash Equilibrium for a behavioural strategy profile.
def IsNashEquilibrium (b : Profile Player BehaviouralStrategy) : Prop :=
  ∀ (i : Player) (b_i' : BehaviouralStrategy i),
    payoff_b (Function.update b i b_i') i ≤ payoff_b b i

-- Axiom 1 (Theorem 7.1): Characterization of mixed strategy NE.
axiom mixed_ne_iff_no_pure_deviation {m : Profile Player MixedStrategy} :
  (∀ i m_i', payoff_m (Function.update m i m_i') i ≤ payoff_m m i) ↔
  (∀ i s_i, payoff_m (Function.update m i (p_to_m s_i)) i ≤ payoff_m m i)

-- Axiom 2 (Kuhn's Theorem): For games with perfect recall, behavioural and mixed strategies
-- are equivalent in terms of payoffs.
axiom kuhns_theorem (h_pr : ExtensiveFormGame.HasPerfectRecall Γ) :
  ∀ (b : Profile Player BehaviouralStrategy), ∃ (m : Profile Player MixedStrategy),
    (payoff_b b = payoff_m m) ∧
    (∀ i s_i, payoff_b (Function.update b i (p_to_b s_i)) i =
               payoff_m (Function.update m i (p_to_m s_i)) i) ∧
    (∀ i b_i', ∃ m_i', payoff_b (Function.update b i b_i') i =
                        payoff_m (Function.update m i m_i') i)
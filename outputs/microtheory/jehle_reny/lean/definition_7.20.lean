import Mathlib
open Filter Topology
open Topology

/-- Definition 7.20: An assessment (p, b) for a finite extensive form game Γ
    is consistent if there is a sequence of completely mixed behavioural
    strategies bⁿ converging to b, such that the associated sequence of
    Bayes' rule induced systems of beliefs pⁿ converges to p.

    Parameters:
    - `H` : type of systems of beliefs (probability assignments over decision nodes)
    - `B` : type of behavioural strategies
    - `IsCompletelyMixed` : predicate identifying completely mixed strategies
    - `bayesBeliefs` : the function assigning Bayes' rule induced beliefs to a
      completely mixed strategy
    - `p` : the system of beliefs in the assessment
    - `b` : the behavioural strategy in the assessment -/
def IsConsistentAssessment
    {H : Type*} [TopologicalSpace H]
    {B : Type*} [TopologicalSpace B]
    (IsCompletelyMixed : B → Prop)
    (bayesBeliefs : B → H)
    (p : H) (b : B) : Prop :=
  ∃ bSeq : ℕ → B,
    (∀ n, IsCompletelyMixed (bSeq n)) ∧
    Tendsto bSeq atTop (𝓝 b) ∧
    Tendsto (bayesBeliefs ∘ bSeq) atTop (𝓝 p)
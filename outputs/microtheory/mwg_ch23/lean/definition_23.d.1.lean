import Mathlib

open MeasureTheory
open Topology

/-- A mechanism design setting for Bayesian games. -/
structure MechanismDesignSetting where
  I : ℕ
  Θ : Fin I → Type*
  S : Fin I → Type*
  X : Type*
  u : Fin I → X → (∀ i, Θ i) → Fin I → ℝ
  inst_meas : ∀ i, MeasurableSpace (Θ i)
  prior : (i : Fin I) → Θ i → Measure (∀ j, Θ j)

attribute [instance] MechanismDesignSetting.inst_meas

instance {md : MechanismDesignSetting} : MeasurableSpace (∀ j, md.Θ j) :=
  MeasurableSpace.pi

/-- A mechanism: strategy spaces and an outcome function. -/
structure Mechanism (md : MechanismDesignSetting) where
  g : (∀ i, md.S i) → md.X

/-- A strategy profile assigns each agent a function from types to strategies. -/
def StrategyProfile (md : MechanismDesignSetting) :=
  ∀ i, md.Θ i → md.S i

/-- Build a strategy profile action: agent i plays si, others follow s* applied to θ. -/
noncomputable def profileAction {md : MechanismDesignSetting}
    (s : StrategyProfile md) (i : Fin md.I) (si : md.S i)
    (θ : ∀ j, md.Θ j) : ∀ j, md.S j :=
  fun j => if h : j = i then h ▸ si else s j (θ j)

/-- Interim expected utility for agent i playing si, given type θ_i,
    when others follow strategy profile s*. -/
noncomputable def interimExpectedUtility {md : MechanismDesignSetting}
    (mech : Mechanism md) (s : StrategyProfile md)
    (i : Fin md.I) (θ_i : md.Θ i) (si : md.S i) : ℝ :=
  ∫ θ, md.u i (mech.g (profileAction s i si θ)) θ i ∂(md.prior i θ_i)

/-- Definition 23.D.1: A strategy profile s* is a Bayesian Nash equilibrium of
    mechanism Γ if, for every agent i and every type θ_i, the equilibrium strategy
    s_i*(θ_i) maximizes interim expected utility over all alternative strategies. -/
structure IsBayesianNashEquilibrium {md : MechanismDesignSetting}
    (mech : Mechanism md) (s : StrategyProfile md) : Prop where
  best_response : ∀ (i : Fin md.I) (θ_i : md.Θ i) (si : md.S i),
    interimExpectedUtility mech s i θ_i (s i θ_i) ≥ interimExpectedUtility mech s i θ_i si
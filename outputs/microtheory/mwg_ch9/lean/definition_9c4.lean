import Mathlib
open Filter

/-! # Sequential Equilibrium (Definition 9.C.4, MWG) -/

/-- A sequential equilibrium of an extensive form game consists of a strategy profile
and belief system satisfying sequential rationality and consistency. -/
structure SequentialEquilibrium
    (InfoSet Node Action : Type*) [TopologicalSpace (InfoSet → Action → ℝ)]
    (isSeqRational : (InfoSet → Action → ℝ) → (InfoSet → Node → ℝ) → Prop)
    (beliefsFromStrategy : (InfoSet → Action → ℝ) → (InfoSet → Node → ℝ))
    (isCompletelyMixed : (InfoSet → Action → ℝ) → Prop) where
  /-- The equilibrium strategy profile. -/
  strategy : InfoSet → Action → ℝ
  /-- The equilibrium belief system. -/
  beliefs : InfoSet → Node → ℝ
  /-- (i) The strategy is sequentially rational given the beliefs. -/
  seq_rational : isSeqRational strategy beliefs
  /-- (ii) There exists a sequence of completely mixed strategies converging to σ
      whose Bayesian beliefs converge to μ. -/
  consistent : ∃ seq : ℕ → (InfoSet → Action → ℝ),
    (∀ k, isCompletelyMixed (seq k)) ∧
    Filter.Tendsto seq Filter.atTop (nhds strategy) ∧
    Filter.Tendsto (beliefsFromStrategy ∘ seq) Filter.atTop (nhds beliefs)
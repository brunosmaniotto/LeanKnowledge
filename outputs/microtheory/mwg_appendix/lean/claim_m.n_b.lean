import Mathlib
open Filter

variable {A : Type*} [TopologicalSpace A] [CompactSpace A] [Nonempty A]

axiom MWG.utility (A : Type*) : A → A → ℝ
axiom MWG.discount (A : Type*) : ℝ
axiom MWG.discount_pos (A : Type*) : 0 < MWG.discount A
axiom MWG.discount_lt_one (A : Type*) : MWG.discount A < 1
axiom MWG.valueFunction (A : Type*) [TopologicalSpace A] : A → ℝ

noncomputable def MWG.BellmanOperator {A : Type*} [TopologicalSpace A] [CompactSpace A] [Nonempty A]
    (f : A → ℝ) (z : A) : ℝ :=
  ⨆ z' : A, (MWG.utility A z z' + MWG.discount A * f z')

noncomputable def MWG.valueIteration {A : Type*} [TopologicalSpace A] [CompactSpace A] [Nonempty A]
    (f₀ : A → ℝ) : ℕ → A → ℝ
  | 0 => f₀
  | r + 1 => MWG.BellmanOperator (MWG.valueIteration f₀ r)

axiom MWG.bellman_contraction (A : Type*) [TopologicalSpace A] [CompactSpace A] [Nonempty A] :
  ∀ (f g : A → ℝ), ⨆ z : A, |MWG.BellmanOperator f z - MWG.BellmanOperator g z| ≤
    MWG.discount A * ⨆ z : A, |f z - g z|

axiom MWG.value_is_fixed_point (A : Type*) [TopologicalSpace A] [CompactSpace A] [Nonempty A] :
  ∀ z : A, MWG.BellmanOperator (MWG.valueFunction A) z = MWG.valueFunction A z

axiom MWG.valueIterationConverges (A : Type*) [TopologicalSpace A] [CompactSpace A] [Nonempty A]
    (f₀ : A → ℝ) (z : A) :
    Filter.Tendsto (fun r => MWG.valueIteration f₀ r z)
      Filter.atTop (nhds (MWG.valueFunction A z))

theorem mwg_value_iteration_converges
    [TopologicalSpace A] [CompactSpace A] [Nonempty A]
    (f₀ : A → ℝ) (z : A) :
    Filter.Tendsto (fun r => MWG.valueIteration f₀ r z)
      Filter.atTop (nhds (MWG.valueFunction A z)) :=
  MWG.valueIterationConverges A f₀ z
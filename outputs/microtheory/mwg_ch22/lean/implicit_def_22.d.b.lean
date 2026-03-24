import Mathlib

open scoped Classical

/-- A social welfare functional maps profiles of utility functions to social orderings. -/
structure SocialWelfareFunction (I : Type*) (A : Type*) where
  /-- Maps a profile of individual utility functions to a social preference order on alternatives. -/
  F : (I → A → ℝ) → (A → A → Prop)

/-- Independence of irrelevant individuals: for any partition of agents into two groups,
    the social preference among utility vectors restricted to one group is independent of
    the utility levels assigned to agents in the other group. -/
structure IndependentOfIrrelevantIndividuals
    {I : Type*} [DecidableEq I] {A : Type*}
    (swf : SocialWelfareFunction I A) : Prop where
  /-- For any subset S of agents, if two profiles agree on S and differ only on Sᶜ
      by a constant reassignment, the social ranking is unchanged. -/
  indep : ∀ (S : Set I) (u u' : I → A → ℝ),
    (∀ i ∈ S, u i = u' i) →
    (∀ (x y : A), swf.F u x y ↔ swf.F u' x y)
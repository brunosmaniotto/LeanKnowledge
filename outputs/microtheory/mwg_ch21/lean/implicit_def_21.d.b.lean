import Mathlib

/-- For a profile of single-peaked preferences over a linearly ordered finite set X,
    the peak of agent i is their most preferred (maximal) alternative. -/
noncomputable def peak
    {X : Type*} [Fintype X] [Nonempty X] [LinearOrder X]
    (pref : X → X → Prop) [DecidableRel pref] [IsTotal X pref] [IsTrans X pref] :
    X :=
  Finset.univ.max' Finset.univ_nonempty

/-- Given a profile of single-peaked preferences for I agents,
    extract the peak alternative for each agent. -/
noncomputable def peakProfile
    {I : Type*} {X : Type*} [Fintype X] [Nonempty X] [LinearOrder X]
    (prefs : I → X → X → Prop)
    [∀ i, DecidableRel (prefs i)]
    [∀ i, IsTotal X (prefs i)]
    [∀ i, IsTrans X (prefs i)] :
    I → X :=
  fun i => peak (prefs i)
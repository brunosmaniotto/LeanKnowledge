import Mathlib
open Topology

variable {X I : Type*}

theorem decisive_expansion_part1 [DecidableEq X] [DecidableEq I]
    (SocialPref : (I → X → X → Prop) → X → X → Prop)
    (S : Finset I)
    (x y z : X)
    (hxy_ne : x ≠ y) (hxz_ne : x ≠ z) (hyz_ne : y ≠ z)
    (hDec : ∀ (P : I → X → X → Prop), (∀ i ∈ S, P i x y) → SocialPref P x y)
    (pareto : ∀ (P : I → X → X → Prop) (a b : X), (∀ i, P i a b) → SocialPref P a b)
    (trans : ∀ (P : I → X → X → Prop) (a b c : X), SocialPref P a b → SocialPref P b c → SocialPref P a c)
    (iia : ∀ (P Q : I → X → X → Prop) (a b : X),
      (∀ i, (P i a b ↔ Q i a b) ∧ (P i b a ↔ Q i b a)) → (SocialPref P a b ↔ SocialPref Q a b))
    : ∀ (P : I → X → X → Prop), (∀ i ∈ S, P i x z) → (∀ i ∈ S, ¬P i z x) →
      (∀ i ∉ S, ¬P i x z) → (∀ i ∉ S, P i z x) → SocialPref P x z := by
  intro P hS_xz hS_nzx hNS_nxz hNS_zx
  -- Construct profile P' that agrees with P on {x,z} but has x>y>z for S, y>z>x for I\S
  let P' : I → X → X → Prop := fun i a b =>
    if a = x ∧ b = z then P i x z
    else if a = z ∧ b = x then P i z x
    else if a = x ∧ b = y then (i ∈ S : Prop)
    else if a = y ∧ b = x then (i ∉ S : Prop)
    else if a = y ∧ b = z then True
    else if a = z ∧ b = y then False
    else True
  have hxy_social : SocialPref P' x y := by
    apply hDec
    intro i hi
    show P' i x y
    simp only [P', hyz_ne, hxz_ne, hxy_ne, and_self, and_true, and_false,
      if_true, if_false, Ne.symm, eq_self_iff_true]
    simp [hxy_ne, hxz_ne, hyz_ne, hxy_ne.symm, hxz_ne.symm, hyz_ne.symm]
    exact hi
  have hyz_social : SocialPref P' y z := by
    apply pareto
    intro i
    show P' i y z
    simp only [P']
    simp [hxy_ne, hxz_ne, hyz_ne, hxy_ne.symm, hxz_ne.symm, hyz_ne.symm]
  have hxz' : SocialPref P' x z := trans P' x y z hxy_social hyz_social
  -- P' agrees with P on {x,z} pairs, so by IIA, SocialPref P' x z ↔ SocialPref P x z
  have hiia : SocialPref P' x z ↔ SocialPref P x z := by
    apply iia P' P x z
    intro i
    simp only [P']
    constructor
    · constructor
      · intro h; simp [hxz_ne, hxz_ne.symm] at h; exact h
      · intro h; simp [hxz_ne, hxz_ne.symm]; exact h
    · constructor
      · intro h; simp [hxz_ne, hxz_ne.symm] at h; exact h
      · intro h; simp [hxz_ne, hxz_ne.symm]; exact h
  exact hiia.mp hxz'
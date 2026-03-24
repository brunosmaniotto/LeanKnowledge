import Mathlib
open Topology

theorem Proposition_21_E_2
    {X I P : Type*} [Fintype X] [Fintype I] [Nonempty I] [DecidableEq X] [DecidableEq I]
    (hX : Fintype.card X ≥ 3)
    (f : (I → P) → X)
    (pref : P → X → X → Prop)
    (pref_strict : ∀ p x y, pref p x y → ¬pref p y x)
    (pref_total : ∀ p x y, x ≠ y → pref p x y ∨ pref p y x)
    (stratProof : ∀ (h : I) (profile : I → P) (p' : P),
      pref (profile h) (f profile) (f (Function.update profile h p')) ∨
      f profile = f (Function.update profile h p'))
    (mullerSatterthwaite :
      (∀ (profile profile' : I → P) (x : X),
        f profile = x →
        (∀ (i : I) (y : X), pref (profile' i) x y → pref (profile i) x y) →
        f profile' = x) →
      ∃ d : I, ∀ profile x y, pref (profile d) x y → f profile ≠ y)
    (singleAgentMono : ∀ (h : I) (profile : I → P) (p' : P),
      (∀ (y : X), pref p' (f profile) y → pref (profile h) (f profile) y) →
      f (Function.update profile h p') = f profile)
    : ∃ d : I, ∀ profile x y, pref (profile d) x y → f profile ≠ y := by
  apply mullerSatterthwaite
  intro profile profile' x hfx hMono
  suffices h : ∀ (S : Finset I) (σ : I → P),
      f σ = x →
      (∀ i y, pref (profile' i) x y → pref (σ i) x y) →
      (∀ i, i ∉ S → σ i = profile' i) →
      f profile' = x by
    exact h Finset.univ profile hfx hMono (fun i hi => absurd (Finset.mem_univ i) hi)
  intro S
  induction S using Finset.induction_on with
  | empty =>
    intro σ hfσ _ hagree
    have heq : σ = profile' := funext (fun i => hagree i (by simp))
    rwa [← heq]
  | @insert a S' ha ih =>
    intro σ hfσ hM hagree
    have hstep : f (Function.update σ a (profile' a)) = f σ := by
      apply singleAgentMono
      intro y hy
      rw [hfσ]
      exact hM a y (by rw [← hfσ]; exact hy)
    apply ih (Function.update σ a (profile' a))
    · rw [hstep, hfσ]
    · intro i y hpref
      by_cases heqi : i = a
      · subst heqi; simp [Function.update]; exact hpref
      · simp [Function.update, heqi]; exact hM i y hpref
    · intro i hi
      by_cases heqi : i = a
      · subst heqi; simp [Function.update]
      · simp [Function.update, heqi]
        apply hagree
        intro hmem
        apply hi
        exact Finset.mem_of_mem_insert_of_ne hmem heqi
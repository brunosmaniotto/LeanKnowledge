import Mathlib.Data.Setoid.Basic
import Mathlib.Logic.Function.Basic
import Mathlib.Data.Set.Basic

open Function Set

universe u v

theorem quotient_theorem_for_sets {S : Type u} {T : Type v} (f : S → T) :
    ∃ (A : Type u) (B : Type v) (q : S → A) (r : A → B) (i : B → T),
      Surjective q ∧ Bijective r ∧ Injective i ∧ f = i ∘ r ∘ q := by
  let R : Setoid S := Setoid.ker f
  let A : Type u := Quotient R
  let q : S → A := Quotient.mk R
  have hq_surj : Surjective q := by
    intro a
    refine Quotient.inductionOn a (fun x => ⟨x, rfl⟩)
  let B : Type v := { y : T | y ∈ Set.range f }
  let i : B → T := Subtype.val
  have hi_inj : Injective i := Subtype.val_injective
  let r : A → B :=
    Quotient.lift (fun x : S => ⟨f x, ⟨x, rfl⟩⟩) (by
      intro x y h
      exact Subtype.ext h)
  have hr_surj : Surjective r := by
    rintro ⟨y, ⟨x, hx⟩⟩
    refine ⟨q x, ?_⟩
    simp [r, q, hx]
  have hr_inj : Injective r := by
    intro a b h
    induction a using Quotient.inductionOn with
    | h x =>
        induction b using Quotient.inductionOn with
        | h y =>
            have h1 : (r (q x)).1 = (r (q y)).1 := congr_arg Subtype.val h
            simp [r, q] at h1
            exact Quotient.sound h1
  have hr_bij : Bijective r := ⟨hr_inj, hr_surj⟩
  have factorization : f = i ∘ r ∘ q := by
    ext x
    simp [i, r, q]
  exact ⟨A, B, q, r, i, hq_surj, hr_bij, hi_inj, factorization⟩
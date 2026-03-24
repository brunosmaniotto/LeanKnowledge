import Mathlib

open Setoid Function

variable {S T : Type*} (f : S → T)

theorem quotient_theorem_for_surjections (hf : Surjective f) :
    ∃! r : Quotient (ker f) → T, Bijective r ∧ r ∘ Quotient.mk (ker f) = f := by
  set q : S → Quotient (ker f) := Quotient.mk (ker f) with q_def
  set r : Quotient (ker f) → T := Quotient.lift f (fun _ _ h => h) with r_def
  have r_comp_eq_f : r ∘ q = f := by
    ext s
    rfl
  have r_surjective : Surjective r := by
    intro t
    obtain ⟨s, hs⟩ := hf t
    refine ⟨q s, ?_⟩
    simp [r, q, hs]
  have r_injective : Injective r := by
    intro x y h
    refine Quotient.inductionOn₂ x y (fun s1 s2 h' => ?_) h
    simp [r, q] at h'
    exact Quotient.sound h'
  have r_bijective : Bijective r := ⟨r_injective, r_surjective⟩
  refine ⟨r, ⟨r_bijective, r_comp_eq_f⟩, ?_⟩
  intro r' ⟨r'_bij, hr'⟩
  ext x
  refine Quotient.inductionOn x (fun s => ?_)
  calc
    r' (q s) = (r' ∘ q) s := rfl
    _ = f s := by rw [hr']
    _ = (r ∘ q) s := by rw [r_comp_eq_f]
    _ = r (q s) := rfl
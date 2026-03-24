import Mathlib

-- Sub-lemma: bijective from injective and surjective
lemma bijective_of_injective_surjective {M N : Type*} (f : M → N) 
    (hinj : Function.Injective f) (hsurj : Function.Surjective f) : 
    Function.Bijective f := by
  exact ⟨hinj, hsurj⟩

-- Sub-lemma: range restriction is injective when original is injective
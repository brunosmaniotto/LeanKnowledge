import Mathlib

variable {M : Type} [Mul M]

theorem exists_submagma_singleton (x : M) (h : x * x = x) :
    ∃ (S : Subsemigroup M), S.carrier = {x} :=
  ⟨{ carrier := {x}
     mul_mem' := by
       intro a b ha hb
       rw [Set.mem_singleton_iff] at ha hb
       rw [ha, hb]
       exact h }, rfl⟩
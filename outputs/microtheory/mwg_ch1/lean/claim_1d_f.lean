import Mathlib

private def cyc : Fin 3 → Fin 3 → Bool
  | 0, 1 => true
  | 1, 2 => true
  | 2, 0 => true
  | _, _ => false

/-- On restricted domains (here: pairwise choices only), WARP does not imply rationalizability.
    The cyclic tournament 0≻1≻2≻0 satisfies WARP on pairs but admits no rationalizing total order. -/
theorem weak_axiom_insufficient_on_restricted_domain :
    ∃ (c : Fin 3 → Fin 3 → Bool),
      -- c is a tournament (WARP on pairs: complete and asymmetric)
      (∀ i j : Fin 3, i ≠ j → c i j = !c j i) ∧
      -- c is not rationalizable (no transitive extension)
      ¬(∀ i j k : Fin 3, c i j = true → c j k = true → c i k = true) :=
  ⟨cyc, by native_decide, by native_decide⟩
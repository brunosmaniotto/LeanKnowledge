import Mathlib

theorem never_best_response_not_implies_strictly_dominated :
    ∃ (payoff : Fin 3 → Fin 2 → ℤ),
      -- Strategy 2 is not strictly dominated
      (∀ i : Fin 3, i ≠ 2 → ∃ j : Fin 2, payoff 2 j ≥ payoff i j) ∧
      -- Strategy 2 is never a best response
      (∀ j : Fin 2, ∃ i : Fin 3, payoff i j > payoff 2 j) :=
  ⟨![![(3 : ℤ), 0], ![0, 3], ![1, 1]],
   fun i hi => by
     fin_cases i
     · exact ⟨1, by decide⟩
     · exact ⟨0, by decide⟩
     · exact absurd rfl hi,
   fun j => by
     fin_cases j
     · exact ⟨0, by decide⟩
     · exact ⟨1, by decide⟩⟩
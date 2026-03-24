import Mathlib
open Topology

/-- With more than two players, there can be strategies that are never a best response
and yet are not strictly dominated. This is a well-known result in game theory
(cf. Pearce 1984) that requires correlated deviations to restore the equivalence. -/
def Claim_8_C_h : Prop :=
  ∃ (n : ℕ) (_ : n > 2)
    (S : Fin n → Type) (_ : ∀ i, Fintype (S i)) (_ : ∀ i, Nonempty (S i))
    (u : (∀ i, S i) → Fin n → ℝ)
    (i : Fin n) (si : S i),
    (∀ (s_rest : ∀ j, S j),
      ∃ (si' : S i),
        u (Function.update s_rest i si') i > u (Function.update s_rest i si) i) ∧
    (¬ ∃ (si' : S i), ∀ (s_rest : ∀ j, S j),
        u (Function.update s_rest i si') i > u (Function.update s_rest i si) i)
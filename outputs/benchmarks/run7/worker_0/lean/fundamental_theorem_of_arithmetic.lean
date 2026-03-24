import Mathlib

axiom Integer_is_Expressible_as_Product_of_Primes (n : ℤ) (h : 1 < n) :
  ∃ (P : Multiset ℤ), (∀ p ∈ P, Prime p) ∧ P.prod = n

axiom Prime_Decomposition_of_Integer_is_Unique (n : ℤ) (h : 1 < n) 
    (P Q : Multiset ℤ) (hP : ∀ p ∈ P, Prime p) (hQ : ∀ p ∈ Q, Prime p) 
    (hprodP : P.prod = n) (hprodQ : Q.prod = n) : Multiset.Rel Associated P Q

theorem fundamental_theorem_of_arithmetic (n : ℤ) (h : 1 < n) :
    ∃ (P : Multiset ℤ), (∀ p ∈ P, Prime p) ∧ P.prod = n ∧
      ∀ (Q : Multiset ℤ), (∀ p ∈ Q, Prime p) → Q.prod = n → Multiset.Rel Associated P Q := by
  rcases Integer_is_Expressible_as_Product_of_Primes n h with ⟨P, hP, hprodP⟩
  refine ⟨P, hP, hprodP, ?_⟩
  intro Q hQ hprodQ
  exact Prime_Decomposition_of_Integer_is_Unique n h P Q hP hQ hprodP hprodQ
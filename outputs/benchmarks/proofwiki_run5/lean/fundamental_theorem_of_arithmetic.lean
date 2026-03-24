import Mathlib

axiom Integer_is_Expressible_as_Product_of_Primes (n : ℤ) (h : n > 1) :
    ∃ (P : Multiset ℤ), (∀ p ∈ P, Prime p) ∧ P.prod = n

axiom Prime_Decomposition_of_Integer_is_Unique (n : ℤ) (h : n > 1) (P Q : Multiset ℤ)
    (hP : ∀ p ∈ P, Prime p) (hQ : ∀ q ∈ Q, Prime q) (hprodP : P.prod = n) (hprodQ : Q.prod = n) :
    Multiset.Rel (fun (a b : ℤ) => Associated a b) P Q

theorem Fundamental_Theorem_of_Arithmetic (n : ℤ) (h : n > 1) :
    ∃ (P : Multiset ℤ), (∀ p ∈ P, Prime p) ∧ P.prod = n ∧
      ∀ (Q : Multiset ℤ), (∀ q ∈ Q, Prime q) → Q.prod = n → Multiset.Rel (fun (a b : ℤ) => Associated a b) P Q := by
  obtain ⟨P, hP, hprod⟩ := Integer_is_Expressible_as_Product_of_Primes n h
  refine ⟨P, hP, hprod, ?_⟩
  intro Q hQ hprodQ
  exact Prime_Decomposition_of_Integer_is_Unique n h P Q hP hQ hprod hprodQ
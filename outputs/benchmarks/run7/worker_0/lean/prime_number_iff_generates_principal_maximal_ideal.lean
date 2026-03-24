import Mathlib

open Ideal

theorem Int.prime_iff_maximal_of_pos {p : ℤ} (hp : 0 < p) : Prime p ↔ (span {p} : Ideal ℤ).IsMaximal := by
  constructor
  · intro h
    have hirr : Irreducible p := Prime.irreducible h
    exact PrincipalIdealRing.isMaximal_of_irreducible hirr
  · intro h
    have h_prime_ideal : (span {p} : Ideal ℤ).IsPrime := h.isPrime
    exact (Ideal.span_singleton_prime (ne_of_gt hp)).mp h_prime_ideal
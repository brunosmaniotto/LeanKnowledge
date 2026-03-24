import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem claim_6B_convexity_of_max_expected_utility
    {A : Type*} [Fintype A] [Nonempty A]
    {N : ℕ} (u : Fin N → A → ℝ) :
    ConvexOn ℝ Set.univ (fun p : Fin N → ℝ =>
      Finset.sup' Finset.univ Finset.univ_nonempty (fun a =>
        ∑ n, p n * u n a)) := by
  constructor
  · exact convex_univ
  · intro p _ q _ α β hα hβ hαβ
    simp only [Set.mem_univ] at *
    apply Finset.sup'_le
    intro a _
    let f : A → ℝ := fun a => ∑ n, p n * u n a
    let g : A → ℝ := fun a => ∑ n, q n * u n a
    have hp : f a ≤ Finset.sup' Finset.univ Finset.univ_nonempty f :=
      Finset.le_sup' f (Finset.mem_univ a)
    have hq : g a ≤ Finset.sup' Finset.univ Finset.univ_nonempty g :=
      Finset.le_sup' g (Finset.mem_univ a)
    have sum_eq : ∑ n, (α • p + β • q) n * u n a = α * f a + β * g a := by
      simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul, f, g]
      simp only [add_mul, mul_assoc]
      rw [Finset.sum_add_distrib]
      congr 1 <;> rw [← Finset.mul_sum]
    rw [sum_eq]
    exact add_le_add (mul_le_mul_of_nonneg_left hp hα) (mul_le_mul_of_nonneg_left hq hβ)
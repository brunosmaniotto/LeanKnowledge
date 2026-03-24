import Mathlib
open BigOperators
open Topology

axiom ExcessDemand : (Fin 3 → ℝ) → (Fin 3 → ℝ)

axiom walras_law : ∀ p : Fin 3 → ℝ,
  ∑ i : Fin 3, p i * ExcessDemand p i = 0

axiom PricePath : ℝ → (Fin 3 → ℝ)

axiom PricePath_deriv : ∀ t : ℝ, ∀ i : Fin 3,
  HasDerivAt (fun s => PricePath s i) (ExcessDemand (PricePath t) i) t

noncomputable def normSq (t : ℝ) : ℝ :=
  ∑ i : Fin 3, (PricePath t i) ^ 2

theorem normSq_deriv_zero (t : ℝ) : HasDerivAt normSq 0 t := by
  unfold normSq
  have hderiv : ∀ i ∈ Finset.univ, HasDerivAt ((fun i s => (PricePath s i) ^ 2) i)
      ((fun i => 2 * PricePath t i * ExcessDemand (PricePath t) i) i) t := by
    intro i _
    show HasDerivAt (fun s => (PricePath s i) ^ 2) (2 * PricePath t i * ExcessDemand (PricePath t) i) t
    have hi := PricePath_deriv t i
    have hpow : HasDerivAt (fun x : ℝ => x ^ 2) (2 * PricePath t i) (PricePath t i) := by
      have h := hasDerivAt_pow 2 (PricePath t i)
      simp only [Nat.cast_ofNat] at h
      convert h using 1; ring
    exact hpow.comp t hi
  have hsum := HasDerivAt.sum hderiv
  simp only at hsum
  have heq : ∑ i : Fin 3, 2 * PricePath t i * ExcessDemand (PricePath t) i = 0 := by
    have hw := walras_law (PricePath t)
    have : ∑ i : Fin 3, 2 * PricePath t i * ExcessDemand (PricePath t) i
        = 2 * ∑ i : Fin 3, PricePath t i * ExcessDemand (PricePath t) i := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro i _; ring
    rw [this, hw, mul_zero]
  rwa [heq] at hsum
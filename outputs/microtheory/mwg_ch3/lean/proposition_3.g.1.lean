import Mathlib

open Finset BigOperators
open Topology
open BigOperators

noncomputable section

variable {L : ℕ} [NeZero L]

theorem shephards_lemma
    (e : (Fin L → ℝ) → ℝ → ℝ)
    (h : (Fin L → ℝ) → ℝ → (Fin L → ℝ))
    (p : Fin L → ℝ) (ū : ℝ)
    (he : DifferentiableAt ℝ (fun q => e q ū) p)
    (envelope : ∀ v : Fin L → ℝ,
      fderiv ℝ (fun q => e q ū) p v = ∑ ℓ : Fin L, h p ū ℓ * v ℓ) :
    ∀ ℓ : Fin L, fderiv ℝ (fun q => e q ū) p (Pi.single ℓ 1) = h p ū ℓ := by
  intro ℓ
  rw [envelope]
  simp [Pi.single_apply, mul_ite, mul_one, mul_zero, Finset.sum_ite_eq', Finset.mem_univ]
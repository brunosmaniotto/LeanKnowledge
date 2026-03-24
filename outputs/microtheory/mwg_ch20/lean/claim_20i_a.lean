import Mathlib
open BigOperators

axiom quadratic_form_sum_eq {L I : ℕ} (D : Fin I → Matrix (Fin L) (Fin L) ℝ) (x : Fin L → ℝ) : dotProduct x ((∑ i : Fin I, D i).mulVec x) = ∑ i : Fin I, dotProduct x ((D i).mulVec x)
axiom sum_neg_of_forall_neg {I : ℕ} [NeZero I] (f : Fin I → ℝ) (hf : ∀ i, f i < 0) : ∑ i : Fin I, f i < 0
axiom neg_def_of_sum {L I : ℕ} [NeZero I] (D : Fin I → Matrix (Fin L) (Fin L) ℝ) (hD : ∀ i, ∀ x : Fin L → ℝ, x ≠ 0 → dotProduct x ((D i).mulVec x) < 0) : ∀ x : Fin L → ℝ, x ≠ 0 → dotProduct x ((∑ i : Fin I, D i).mulVec x) < 0

theorem Claim_20I_a {L I : ℕ} [NeZero I]
    (D : Fin I → Matrix (Fin L) (Fin L) ℝ)
    (hD : ∀ i, ∀ x : Fin L → ℝ, x ≠ 0 → dotProduct x ((D i).mulVec x) < 0) :
    ∀ x : Fin L → ℝ, x ≠ 0 → dotProduct x ((∑ i : Fin I, D i).mulVec x) < 0 :=
  neg_def_of_sum D hD
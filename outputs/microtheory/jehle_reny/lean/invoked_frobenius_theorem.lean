import Mathlib

structure DemandSystem (L : ℕ) where
  x : Fin L → (Fin L → ℝ) → ℝ → ℝ
  Dx_dp : Fin L → Fin L → (Fin L → ℝ) → ℝ → ℝ
  Dx_dy : Fin L → (Fin L → ℝ) → ℝ → ℝ

noncomputable def slutskyEntry {L : ℕ} (D : DemandSystem L)
    (i j : Fin L) (p : Fin L → ℝ) (y : ℝ) : ℝ :=
  D.Dx_dp i j p y + D.x j p y * D.Dx_dy i p y

def SlutskySymmetric {L : ℕ} (D : DemandSystem L) : Prop :=
  ∀ (i j : Fin L) (p : Fin L → ℝ) (y : ℝ),
    slutskyEntry D i j p y = slutskyEntry D j i p y

axiom PDESolvable : {L : ℕ} → DemandSystem L → Prop

axiom frobenius_forward : ∀ {L : ℕ} (D : DemandSystem L),
  PDESolvable D → SlutskySymmetric D

axiom frobenius_backward : ∀ {L : ℕ} (D : DemandSystem L),
  SlutskySymmetric D → PDESolvable D
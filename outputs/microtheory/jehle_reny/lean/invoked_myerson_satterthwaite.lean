import Mathlib
open Topology

structure BilateralTradeSetting where
  θ₁L : ℝ
  θ₁H : ℝ
  θ₂L : ℝ
  θ₂H : ℝ

structure Mechanism (n : ℕ) (Θ : Fin n → Type) (X : Type) where
  outcome : (i : Fin n) → Θ i → X

noncomputable def ExPostEfficient {n Θ X} (M : Mechanism n Θ X) : Prop := False
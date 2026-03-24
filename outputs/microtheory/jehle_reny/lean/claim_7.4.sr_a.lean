import Mathlib

section Claim_7_4_SR_a

variable (Player : Type) [Fintype Player] [DecidableEq Player]
variable (InfoSet : Player → Type) [∀ i, Fintype (InfoSet i)]
variable (Action : Type) [Fintype Action] [DecidableEq Action]
variable (Payoff : ∀ i, InfoSet i → (Action → ℝ) → ℝ → ℝ)

structure Assessment where
  b : ∀ i, InfoSet i → Action → ℝ
  μ : ∀ i, InfoSet i → ℝ

noncomputable def IsBestResponseAt (a : Assessment Player InfoSet Action) (i : Player) (I : InfoSet i) : Prop :=
  ∀ (b' : Action → ℝ), Payoff i I b' (a.μ i I) ≤ Payoff i I (a.b i I) (a.μ i I)
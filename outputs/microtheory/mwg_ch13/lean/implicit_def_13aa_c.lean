import Mathlib

structure SignalingPBE (Θ A S : Type*) where
  u₁ : A → S → Θ → ℝ
  aStar : Θ → A
  sStar : A → S
  μ : Θ → A → ℝ
  bestResponses : A → Set S

def SignalingPBE.eqPayoff (G : SignalingPBE Θ A S) (θ : Θ) : ℝ :=
  G.u₁ (G.aStar θ) (G.sStar (G.aStar θ)) θ
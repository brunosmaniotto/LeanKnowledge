import Mathlib
open Topology

structure GeneralBayesianSetting where
  n : ℕ
  hn : n > 0
  Θ : Fin n → Type*
  X : Type*
  u : Fin n → X → (∀ i, Θ i) → ℝ
  f : (∀ i, Θ i) → X

def GeneralBIC (S : GeneralBayesianSetting)
    (E_neg_i : Fin S.n → (i : Fin S.n) → S.Θ i → ((∀ j, S.Θ j) → ℝ) → ℝ) : Prop :=
  ∀ (i : Fin S.n) (θ_i : S.Θ i) (θ_hat_i : S.Θ i),
    E_neg_i i i θ_i (fun θ => S.u i (S.f θ) θ) ≥
    E_neg_i i i θ_i (fun θ => S.u i (S.f (Function.update θ i θ_hat_i)) θ)
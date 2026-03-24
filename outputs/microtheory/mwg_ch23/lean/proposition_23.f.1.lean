import Mathlib
open BigOperators Finset

universe u

structure SCFEnv where
  I : Type*
  [finI : Fintype I]
  Θ : I → Type*
  [finΘ : ∀ i, Fintype (Θ i)]
  F : Type*
  u : (i : I) → Θ i → F → ℝ
  w : (i : I) → Θ i → ℝ
  w_nonneg : ∀ i θ, 0 ≤ w i θ
  w_sum_pos : ∀ i, 0 < ∑ θ : Θ i, w i θ

namespace SCFEnv
variable (env : SCFEnv)
instance : Fintype env.I := env.finI
instance (i : env.I) : Fintype (env.Θ i) := env.finΘ i

noncomputable def exAnte (i : env.I) (f : env.F) : ℝ :=
  ∑ θ : env.Θ i, env.w i θ * env.u i θ f

def ExAnteEff (S : Set env.F) (f : env.F) : Prop :=
  f ∈ S ∧ ¬∃ f' ∈ S,
    (∀ i, env.exAnte i f' ≥ env.exAnte i f) ∧
    (∃ i, env.exAnte i f' > env.exAnte i f)
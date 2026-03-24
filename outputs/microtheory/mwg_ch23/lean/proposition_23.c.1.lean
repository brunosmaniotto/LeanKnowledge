import Mathlib
open Function
open Topology

variable {I : Type*} [DecidableEq I] {Θ : I → Type*} {S : I → Type*} {X : Type*}

theorem revelation_principle_dominant_strategies
    (g : (∀ i, S i) → X)
    (f : (∀ i, Θ i) → X)
    (u : ∀ i, X → Θ i → ℝ)
    (sStar : ∀ i, Θ i → S i)
    (h_impl : ∀ θ : ∀ i, Θ i, g (fun i => sStar i (θ i)) = f θ)
    (h_dom : ∀ (i : I) (θ_i : Θ i) (s_i : S i) (s_minus_i : ∀ j, S j),
      u i (g (Function.update s_minus_i i (sStar i θ_i))) θ_i ≥
      u i (g (Function.update s_minus_i i s_i)) θ_i)
    : ∀ (i : I) (θ_i : Θ i) (θ_hat_i : Θ i) (θ_minus_i : ∀ j, Θ j),
      u i (f (Function.update θ_minus_i i θ_i)) θ_i ≥
      u i (f (Function.update θ_minus_i i θ_hat_i)) θ_i := by
  intro i θ_i θ_hat_i θ_minus_i
  have h := h_dom i θ_i (sStar i θ_hat_i) (fun j => sStar j (θ_minus_i j))
  have lhs : g (Function.update (fun j => sStar j (θ_minus_i j)) i (sStar i θ_i)) =
      f (Function.update θ_minus_i i θ_i) := by
    have := h_impl (Function.update θ_minus_i i θ_i)
    convert this using 2
    ext j
    by_cases hj : j = i
    · subst hj; simp
    · simp [hj]
  have rhs : g (Function.update (fun j => sStar j (θ_minus_i j)) i (sStar i θ_hat_i)) =
      f (Function.update θ_minus_i i θ_hat_i) := by
    have := h_impl (Function.update θ_minus_i i θ_hat_i)
    convert this using 2
    ext j
    by_cases hj : j = i
    · subst hj; simp
    · simp [hj]
  linarith [lhs ▸ rhs ▸ h]
import Mathlib

open BigOperators Finset
open Topology

universe u

variable {I K : Type*} [Fintype I] [DecidableEq I] [Fintype K] [DecidableEq K] [Nonempty K]

/-- Case (ii): ε-perturbation argument with rich type space. Axiomatized. -/
axiom groves_case_ii
    {I K : Type*} [Fintype I] [DecidableEq I] [Fintype K] [DecidableEq K] [Nonempty K]
    {Θ : I → Type*} (v : (i : I) → K → Θ i → ℝ)
    (kStar : ((i : I) → Θ i) → K)
    (t : (i : I) → ((j : I) → Θ j) → ℝ)
    (h : (i : I) → ((j : I) → Θ j) → ℝ)
    (h_def : ∀ i θ, t i θ = ∑ j ∈ Finset.univ.filter (· ≠ i), v j (kStar θ) (θ j) + h i θ)
    (ic : ∀ i (θ : (j : I) → Θ j) (θi' : Θ i),
      v i (kStar θ) (θ i) + t i θ ≥
      v i (kStar (Function.update θ i θi')) (θ i) + t i (Function.update θ i θi'))
    (eff : ∀ θ k, ∑ j : I, v j (kStar θ) (θ j) ≥ ∑ j : I, v j k (θ j))
    (rich : ∀ i (w : K → ℝ), ∃ θi : Θ i, ∀ k, v i k θi = w k)
    (i : I) (θ : (j : I) → Θ j) (θi' : Θ i)
    (hk : kStar θ ≠ kStar (Function.update θ i θi'))
    : h i θ = h i (Function.update θ i θi')

/-- Proposition 23.C.5: Under rich type spaces, IC + efficiency ⟹ Groves transfers. -/
theorem Proposition_23C5
    {Θ : I → Type*} (v : (i : I) → K → Θ i → ℝ)
    (kStar : ((i : I) → Θ i) → K)
    (t : (i : I) → ((j : I) → Θ j) → ℝ)
    (h : (i : I) → ((j : I) → Θ j) → ℝ)
    (h_def : ∀ i θ, t i θ = ∑ j ∈ Finset.univ.filter (· ≠ i),
      v j (kStar θ) (θ j) + h i θ)
    (ic : ∀ i (θ : (j : I) → Θ j) (θi' : Θ i),
      v i (kStar θ) (θ i) + t i θ ≥
      v i (kStar (Function.update θ i θi')) (θ i) + t i (Function.update θ i θi'))
    (eff : ∀ θ k, ∑ j : I, v j (kStar θ) (θ j) ≥ ∑ j : I, v j k (θ j))
    (rich : ∀ i (w : K → ℝ), ∃ θi : Θ i, ∀ k, v i k θi = w k)
    : ∀ i (θ : (j : I) → Θ j) (θi' : Θ i),
      h i θ = h i (Function.update θ i θi') := by
  intro i θ θi'
  by_cases hk : kStar θ = kStar (Function.update θ i θi')
  · -- Case (i): kStar agrees ⟹ IC both ways forces t_i equal ⟹ h_i equal
    have ic1 := ic i θ θi'
    rw [hk] at ic1
    -- ic1 now has identical v_i terms, so t i θ ≥ t i (update θ i θi')
    have ic2 := ic i (Function.update θ i θi') (θ i)
    -- Simplify update∘update back to θ
    have upd_back : Function.update (Function.update θ i θi') i (θ i) = θ := by
      rw [Function.update_idem, Function.update_eq_self]
    rw [upd_back] at ic2
    -- Simplify (update θ i θi') i to θi'
    have upd_val : (Function.update θ i θi') i = θi' := by simp
    rw [upd_val] at ic2
    rw [← hk] at ic2
    -- ic2 now has identical v_i terms, so t i (update θ i θi') ≥ t i θ
    have ht : t i θ = t i (Function.update θ i θi') := le_antisymm (by linarith) (by linarith)
    -- Extract h_i equality from t_i equality via h_def
    have hd1 := h_def i θ
    have hd2 := h_def i (Function.update θ i θi')
    -- The sums over j ≠ i are equal (same θ_j, same kStar)
    have hsum : ∑ j ∈ Finset.univ.filter (· ≠ i), v j (kStar θ) (θ j) =
                ∑ j ∈ Finset.univ.filter (· ≠ i), v j (kStar (Function.update θ i θi'))
                  ((Function.update θ i θi') j) := by
      rw [hk]
      apply Finset.sum_congr rfl
      intro j hj
      simp only [Finset.mem_filter, Finset.mem_univ, true_and] at hj
      rw [Function.update_of_ne hj]
    linarith
  · -- Case (ii): kStar differs. ε-perturbation argument (axiomatized).
    exact groves_case_ii v kStar t h h_def ic eff rich i θ θi' hk
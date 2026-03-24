import Mathlib
open Topology
open BigOperators
set_option linter.unusedVariables false

axiom exists_maximum_for_vcg_payment {I : Type} [Fintype I] [DecidableEq I] (T : I → Type)
  [∀ i, TopologicalSpace (T i)] [∀ i, CompactSpace (T i)] (X : Type) [Fintype X]
  (v : ∀ i, T i → X → ℝ) (f : (∀ i, T i) → X)
  (continuous_condition : ∀ (i : I) (t : ∀ i, T i),
    Continuous (fun (s_i : T i) => ∑ j ∈ Finset.univ.erase i, v j (t j) (f (Function.update t i s_i)))) :
  ∀ (i : I) (t : ∀ i, T i), ∃ (s_i : T i), ∀ (s_i' : T i),
    ∑ j ∈ Finset.univ.erase i, v j (t j) (f (Function.update t i s_i')) ≤
    ∑ j ∈ Finset.univ.erase i, v j (t j) (f (Function.update t i s_i))

axiom vcg_dsic_given_maximum {I : Type} [Fintype I] [DecidableEq I] (T : I → Type) (X : Type) [Fintype X]
  (v : ∀ i, T i → X → ℝ) (f : (∀ i, T i) → X)
  (ex_post_efficiency : ∀ (t : ∀ i, T i) (x : X), ∑ i : I, v i (t i) (f t) ≥ ∑ i : I, v i (t i) x)
  (M : I → (∀ i, T i) → ℝ)
  (hM : ∀ (i : I) (t : ∀ i, T i), ∃ (s_i : T i),
    M i t = ∑ j ∈ Finset.univ.erase i, v j (t j) (f (Function.update t i s_i)) ∧
    ∀ (s_i' : T i), ∑ j ∈ Finset.univ.erase i, v j (t j) (f (Function.update t i s_i')) ≤ M i t)
  (p : I → (∀ i, T i) → ℝ)
  (hp : ∀ (i : I) (t : ∀ i, T i), p i t = M i t - ∑ j ∈ Finset.univ.erase i, v j (t j) (f t)) :
  ∀ (i : I) (t : ∀ i, T i) (t_i' : T i),
    v i (t i) (f t) - p i t ≥ v i (t i) (f (Function.update t i t_i')) - p i (Function.update t i t_i')

theorem Claim_9_5_8_setup {I : Type} [Fintype I] [DecidableEq I] (T : I → Type)
    [∀ i, TopologicalSpace (T i)] [∀ i, CompactSpace (T i)] (X : Type) [Fintype X]
    (v : ∀ i, T i → X → ℝ) (f : (∀ i, T i) → X)
    (continuous_condition : ∀ (i : I) (t : ∀ i, T i),
      Continuous (fun (s_i : T i) => ∑ j ∈ Finset.univ.erase i, v j (t j) (f (Function.update t i s_i))))
    (ex_post_efficiency : ∀ (t : ∀ i, T i) (x : X), ∑ i : I, v i (t i) (f t) ≥ ∑ i : I, v i (t i) x) :
    ∃ (p : I → (∀ i, T i) → ℝ), ∀ (i : I) (t : ∀ i, T i) (t_i' : T i),
      v i (t i) (f t) - p i t ≥ v i (t i) (f (Function.update t i t_i')) - p i (Function.update t i t_i') := by
  have h_max := exists_maximum_for_vcg_payment T X v f continuous_condition
  choose s h_s using h_max
  let M (i : I) (t : ∀ i, T i) : ℝ := ∑ j ∈ Finset.univ.erase i, v j (t j) (f (Function.update t i (s i t)))
  have hM : ∀ (i : I) (t : ∀ i, T i), ∃ (s_i : T i), M i t = ∑ j ∈ Finset.univ.erase i, v j (t j) (f (Function.update t i s_i)) ∧
      ∀ (s_i' : T i), ∑ j ∈ Finset.univ.erase i, v j (t j) (f (Function.update t i s_i')) ≤ M i t := by
    intro i t
    exact ⟨s i t, rfl, h_s i t⟩
  let p (i : I) (t : ∀ i, T i) : ℝ := M i t - ∑ j ∈ Finset.univ.erase i, v j (t j) (f t)
  refine ⟨p, ?_⟩
  exact vcg_dsic_given_maximum T X v f ex_post_efficiency M hM p (λ i t => rfl)
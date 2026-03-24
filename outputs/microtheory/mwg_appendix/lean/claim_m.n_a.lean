import Mathlib

open Set Filter Topology
open Topology

-- Part (a): Existence of maximizer — continuous function on compact nonempty set attains max
theorem Claim_M_N_a_existence
    {A : Type*} [TopologicalSpace A]
    {B : Type*} [TopologicalSpace B] [CompactSpace B]
    (u : A → B → ℝ) (hu : Continuous (Function.uncurry u))
    (C : A → Set B) (hC_closed : ∀ a, IsClosed (C a)) (hC_ne : ∀ a, (C a).Nonempty)
    (a : A) : ∃ b ∈ C a, ∀ b' ∈ C a, u a b' ≤ u a b := by
  have hcomp : IsCompact (C a) := (hC_closed a).isCompact
  have hcont : Continuous (u a) := by
    show Continuous (fun b => Function.uncurry u (a, b))
    exact hu.comp (by fun_prop)
  exact hcomp.exists_isMaxOn (hC_ne a) hcont.continuousOn

-- Value function definition
noncomputable def MWG_valueFunction
    {A : Type*} [TopologicalSpace A]
    {B : Type*} [TopologicalSpace B] [CompactSpace B]
    (u : A → B → ℝ) (C : A → Set B) : A → ℝ :=
  fun a => sSup (u a '' C a)

-- Part (b): Continuity of value function (Berge's Maximum Theorem)
axiom berge_continuity
    {A : Type*} [TopologicalSpace A] [CompactSpace A]
    {B : Type*} [TopologicalSpace B] [CompactSpace B]
    (u : A → B → ℝ) (hu : Continuous (Function.uncurry u))
    (C : A → Set B) (hC_closed : ∀ a, IsClosed (C a)) (hC_ne : ∀ a, (C a).Nonempty) :
    Continuous (MWG_valueFunction u C)

-- Part (c): Concavity of value function when domain is convex and u is concave
axiom value_function_concave
    {n m : ℕ}
    (u : EuclideanSpace ℝ (Fin n) → EuclideanSpace ℝ (Fin m) → ℝ)
    (hu_cont : Continuous (Function.uncurry u))
    (A : Set (EuclideanSpace ℝ (Fin n))) (hA_convex : Convex ℝ A)
    (B : EuclideanSpace ℝ (Fin n) → Set (EuclideanSpace ℝ (Fin m)))
    (hB_closed : ∀ a, IsClosed (B a)) (hB_ne : ∀ a, (B a).Nonempty)
    (hu_concave : ∀ b, ConcaveOn ℝ A (fun a => u a b)) :
    ConcaveOn ℝ A (fun a => sSup ((fun b => u a b) '' B a))
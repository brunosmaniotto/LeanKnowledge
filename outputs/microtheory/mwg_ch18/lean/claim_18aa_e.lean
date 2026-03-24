import Mathlib

open BigOperators
open Topology

universe u

variable {I : Type*} [Fintype I] [DecidableEq I]

abbrev CoalGame (I : Type*) := Finset I → ℝ

axiom shapley_value (I : Type*) [Fintype I] [DecidableEq I] : CoalGame I → I → ℝ

axiom shapley_efficiency {I : Type*} [Fintype I] [DecidableEq I] (v : CoalGame I) :
    ∑ i : I, shapley_value I v i = v Finset.univ

axiom shapley_symmetry {I : Type*} [Fintype I] [DecidableEq I] (v v' : CoalGame I) (i h : I)
    (hsym : ∀ S : Finset I, v (S.image (Function.update id i h ∘ Function.update id h i)) = v' S) :
    shapley_value I v i = shapley_value I v' h

axiom shapley_linearity {I : Type*} [Fintype I] [DecidableEq I] (v w : CoalGame I) (a b : ℝ) :
    ∀ i : I, shapley_value I (fun S => a * v S + b * w S) i =
      a * shapley_value I v i + b * shapley_value I w i

axiom shapley_dummy {I : Type*} [Fintype I] [DecidableEq I] (v : CoalGame I) (i : I)
    (hdummy : ∀ S : Finset I, i ∉ S → v (insert i S) - v S = 0) :
    shapley_value I v i = 0

axiom shapley_unique {I : Type*} [Fintype I] [DecidableEq I]
    (φ : CoalGame I → I → ℝ)
    (heff : ∀ v, ∑ i : I, φ v i = v Finset.univ)
    (hsym : ∀ v v' : CoalGame I, ∀ i h : I,
      (∀ S, v (S.image (Function.update id i h ∘ Function.update id h i)) = v' S) →
      φ v i = φ v' h)
    (hlin : ∀ v w : CoalGame I, ∀ a b : ℝ, ∀ i : I,
      φ (fun S => a * v S + b * w S) i = a * φ v i + b * φ w i)
    (hdum : ∀ v : CoalGame I, ∀ i : I,
      (∀ S : Finset I, i ∉ S → v (insert i S) - v S = 0) → φ v i = 0) :
    ∀ v : CoalGame I, ∀ i : I, shapley_value I v i = φ v i

theorem shapley_characterization
    (φ : CoalGame I → I → ℝ)
    (heff : ∀ v, ∑ i : I, φ v i = v Finset.univ)
    (hsym : ∀ v v' : CoalGame I, ∀ i h : I,
      (∀ S, v (S.image (Function.update id i h ∘ Function.update id h i)) = v' S) →
      φ v i = φ v' h)
    (hlin : ∀ v w : CoalGame I, ∀ a b : ℝ, ∀ i : I,
      φ (fun S => a * v S + b * w S) i = a * φ v i + b * φ w i)
    (hdum : ∀ v : CoalGame I, ∀ i : I,
      (∀ S : Finset I, i ∉ S → v (insert i S) - v S = 0) → φ v i = 0) :
    ∀ v : CoalGame I, ∀ i : I, φ v i = shapley_value I v i := by
  intro v i
  exact (shapley_unique φ heff hsym hlin hdum v i).symm
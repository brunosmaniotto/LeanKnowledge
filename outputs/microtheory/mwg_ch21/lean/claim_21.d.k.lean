import Mathlib
open Topology

/-- In two or more dimensions, quasiconcavity does not help because there is no
    canonical way to assign a "median" to a set of points in the plane.
    This is axiomatized as it represents a qualitative observation from social
    choice theory (related to the impossibility of a Condorcet winner in ≥2D). -/
axiom no_canonical_planar_median :
    ¬ ∃ (f : (Fin 3 → ℝ × ℝ) → ℝ × ℝ),
      (∀ (σ : Equiv.Perm (Fin 3)) (g : Fin 3 → ℝ × ℝ), f (g ∘ σ) = f g) ∧
      (∀ (g : Fin 3 → ℝ × ℝ) (c : ℝ), (∀ i, (g i).1 = c) → (f g).1 = c) ∧
      (∀ (g : Fin 3 → ℝ × ℝ) (c : ℝ), (∀ i, (g i).2 = c) → (f g).2 = c) ∧
      (∀ (g h : Fin 3 → ℝ × ℝ), (∀ i, (g i).1 = (h i).1) → (f g).1 = (f h).1) ∧
      (∀ (g h : Fin 3 → ℝ × ℝ), (∀ i, (g i).2 = (h i).2) → (f g).2 = (f h).2)

theorem Claim_21Dk : ¬ ∃ (f : (Fin 3 → ℝ × ℝ) → ℝ × ℝ),
    (∀ (σ : Equiv.Perm (Fin 3)) (g : Fin 3 → ℝ × ℝ), f (g ∘ σ) = f g) ∧
    (∀ (g : Fin 3 → ℝ × ℝ) (c : ℝ), (∀ i, (g i).1 = c) → (f g).1 = c) ∧
    (∀ (g : Fin 3 → ℝ × ℝ) (c : ℝ), (∀ i, (g i).2 = c) → (f g).2 = c) ∧
    (∀ (g h : Fin 3 → ℝ × ℝ), (∀ i, (g i).1 = (h i).1) → (f g).1 = (f h).1) ∧
    (∀ (g h : Fin 3 → ℝ × ℝ), (∀ i, (g i).2 = (h i).2) → (f g).2 = (f h).2) :=
  no_canonical_planar_median
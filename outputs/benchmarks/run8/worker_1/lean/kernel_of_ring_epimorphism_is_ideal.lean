import Mathlib

-- Axiomatized sub-lemmas as given in the problem description.
-- These correspond to parts of the First Isomorphism Theorem for Rings.

-- This axiom states the existence of an isomorphism from the quotient ring to the codomain.
axiom existence_of_quotient_iso {R₁ R₂ : Type*} [Ring R₁] [Ring R₂] (φ : R₁ →+* R₂) (hφ : Function.Surjective φ) : ∃ g : (R₁ ⧸ RingHom.ker φ) ≃+* R₂, g.toRingHom.comp (Ideal.Quotient.mk (RingHom.ker φ)) = φ

-- This axiom states that the isomorphism from the quotient ring is unique.
axiom uniqueness_of_quotient_iso {R₁ R₂ : Type*} [Ring R₁] [Ring R₂] (φ : R₁ →+* R₂) (g₁ g₂ : (R₁ ⧸ RingHom.ker φ) ≃+* R₂) (h₁ : g₁.toRingHom.comp (Ideal.Quotient.mk (RingHom.ker φ)) = φ) (h₂ : g₂.toRingHom.comp (Ideal.Quotient.mk (RingHom.ker φ)) = φ) : g₁ = g₂

-- This axiom states that a surjective ring homomorphism is an isomorphism if and only if its kernel is trivial.
axiom surjective_hom_isomorphism_iff_ker_trivial {R₁ R₂ : Type*} [Ring R₁] [Ring R₂] (φ : R₁ →+* R₂) (hφ : Function.Surjective φ) : Function.Bijective φ ↔ RingHom.ker φ = ⊥

-- Note: The fact that the kernel of a ring homomorphism is an ideal is true by definition in Mathlib.
-- The type of `RingHom.ker φ` is `Ideal R₁`, so there is nothing to prove for that part.

/--
This theorem formalizes the core results of the First Isomorphism Theorem for Rings,
assuming the necessary components as axioms.

Given a ring epimorphism (a surjective ring homomorphism) `φ : R₁ → R₂`:
1. There exists a unique ring isomorphism `g` from the quotient ring `R₁ / ker φ` to `R₂`
   such that `g` composed with the canonical quotient map equals `φ`.
2. `φ` is itself an isomorphism if and only if its kernel is the trivial ideal `{0}`.
-/
theorem kernel_of_ring_epimorphism_is_ideal
    {R₁ R₂ : Type*} [Ring R₁] [Ring R₂] (φ : R₁ →+* R₂) (hφ : Function.Surjective φ) :
    (∃! g : (R₁ ⧸ RingHom.ker φ) ≃+* R₂, g.toRingHom.comp (Ideal.Quotient.mk (RingHom.ker φ)) = φ) ∧
    (Function.Bijective φ ↔ RingHom.ker φ = ⊥) := by
  constructor
  · -- Part 1: Prove the unique existence of the isomorphism `g`.
    -- The `existence_of_quotient_iso` axiom gives us an isomorphism `g`.
    obtain ⟨g, hg_prop⟩ := existence_of_quotient_iso φ hφ
    -- We now prove that such a `g` exists and is unique.
    use g
    constructor
    · -- The existence part is exactly what the axiom provided.
      exact hg_prop
    · -- For uniqueness, we take another isomorphism `g'` with the same property.
      intro g' hg'_prop
      -- The `uniqueness_of_quotient_iso` axiom states that if two isomorphisms
      -- `g` and `g'` satisfy the property, they must be equal.
      -- The axiom proves `g = g'`, but our goal is `g' = g`. We use symmetry of equality.
      exact (uniqueness_of_quotient_iso φ g g' hg_prop hg'_prop).symm
  · -- Part 2: Prove the condition for `φ` being an isomorphism.
    -- This is a direct application of the `surjective_hom_isomorphism_iff_ker_trivial` axiom.
    exact surjective_hom_isomorphism_iff_ker_trivial φ hφ
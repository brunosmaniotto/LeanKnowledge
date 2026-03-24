import Mathlib

-- This definition shows that the property of being a module is preserved under epimorphisms.
-- An epimorphism in this context is a surjective map that preserves the module structure (a linear map).
-- We are given a function `φ : G → H` and hypotheses that it is surjective (`hφ_surj`),
-- preserves addition (`hφ_add`), and preserves scalar multiplication (`hφ_smul`).
-- The target `H` is assumed to have an additive structure and a scalar multiplication
-- that are compatible with `φ`. We then show that `H` satisfies all the module axioms.
--
-- The Mathlib lemma `Function.Surjective.module` is the perfect tool for this.
-- It takes the function `φ`, a proof of its surjectivity, and proofs of its linearity,
-- and constructs the `Module R H` instance. This is a standard way to transfer algebraic
-- structures in Mathlib.
--
-- We use `noncomputable def` because `Function.Surjective` relies on the axiom of choice
-- to produce a right
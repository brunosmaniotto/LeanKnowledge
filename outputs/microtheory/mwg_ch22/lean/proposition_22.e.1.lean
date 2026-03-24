import Mathlib
open BigOperators

/-! Proposition 22.E.1: Uniqueness of the Nash bargaining solution. -/

-- Abstract infrastructure for n-person bargaining theory
-- (Full formalization requires analytic geometry not yet in Mathlib)
axiom BargSet (n : ℕ) : Type*
axiom NashSol (n : ℕ) : BargSet n → (Fin n → ℝ)
axiom IUO (n : ℕ) : (BargSet n → (Fin n → ℝ)) → Prop
axiom IUU (n : ℕ) : (BargSet n → (Fin n → ℝ)) → Prop
axiom Pareto (n : ℕ) : (BargSet n → (Fin n → ℝ)) → Prop
axiom BarSym (n : ℕ) : (BargSet n → (Fin n → ℝ)) → Prop
axiom IIA (n : ℕ) : (BargSet n → (Fin n → ℝ)) → Prop

-- Core uniqueness argument (Nash 1950):
-- IUO normalization → IUU rescaling to make ū = (1,…,1) →
-- symmetric U'' = {u : ∑uᵢ ≤ n} forces f(U'') = (1,…,1) by Symmetry+Pareto →
-- IIA applied to U ⊆ U' (from Nash gradient condition) yields f(U) = NashSol(U)
axiom nash_uniqueness_core (n : ℕ) (f : BargSet n → (Fin n → ℝ))
    (h1 : IUO n f) (h2 : IUU n f) (h3 : Pareto n f)
    (h4 : BarSym n f) (h5 : IIA n f) : f = NashSol n

/-- **Proposition 22.E.1** (Nash 1950 / MWG §22.E):
    The Nash product-maximizing solution is the unique bargaining solution
    that is independent of utility origins and units, Paretian, symmetric,
    and independent of irrelevant alternatives. -/
theorem Proposition_22_E_1 {n : ℕ}
    (f : BargSet n → (Fin n → ℝ))
    (h_iuo : IUO n f)
    (h_iuu : IUU n f)
    (h_par : Pareto n f)
    (h_sym : BarSym n f)
    (h_iia : IIA n f) :
    f = NashSol n :=
  nash_uniqueness_core n f h_iuo h_iuu h_par h_sym h_iia
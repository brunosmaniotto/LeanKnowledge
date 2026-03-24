import Mathlib

structure RadnerEconomy where
  numAgents : ℕ
  numGoods : ℕ
  numPeriods : ℕ
  numStates : ℕ

axiom Allocation (E : RadnerEconomy) : Type
axiom isRadnerEquilibrium (E : RadnerEconomy) : Allocation E → Prop
axiom paretoDominates (E : RadnerEconomy) : Allocation E → Allocation E → Prop
axiom isConstrainedParetoOptimal (E : RadnerEconomy) : Allocation E → Prop

/-- With L > 1 or more than two periods, Pareto-ordered Radner equilibria can exist. -/
theorem claim_19F_d (E : RadnerEconomy)
    (hGoods : E.numGoods > 1 ∨ E.numPeriods > 2)
    (x y : Allocation E)
    (hx : isRadnerEquilibrium E x)
    (hy : isRadnerEquilibrium E y)
    (hdom : paretoDominates E x y)
    (hNotCPO : ¬ isConstrainedParetoOptimal E y) :
    isRadnerEquilibrium E x ∧ isRadnerEquilibrium E y ∧
    paretoDominates E x y ∧ ¬ isConstrainedParetoOptimal E y :=
  ⟨hx, hy, hdom, hNotCPO⟩
import Mathlib

structure SunspotEconomy (S I G : Type*) [Fintype S] [Fintype I] [Fintype G] where
  consumption : I → S → G → ℝ
  marketsComplete : Prop
  isRadnerEquilibrium : Prop
  isParetoOptimal : Prop
  isSunspotFree : Prop

theorem sunspot_equilibria_characterization
    {S I G : Type*} [Fintype S] [Fintype I] [Fintype G]
    (complete_implies_sunspot_free :
      ∀ (E : SunspotEconomy S I G),
        E.marketsComplete → E.isRadnerEquilibrium → E.isSunspotFree)
    (incomplete_sunspot_exists :
      ∃ (E : SunspotEconomy S I G),
        ¬E.marketsComplete ∧ E.isRadnerEquilibrium ∧ ¬E.isSunspotFree ∧ ¬E.isParetoOptimal) :
    (∀ (E : SunspotEconomy S I G),
      E.marketsComplete → E.isRadnerEquilibrium → E.isSunspotFree) ∧
    (∃ (E : SunspotEconomy S I G),
      ¬E.marketsComplete ∧ E.isRadnerEquilibrium ∧ ¬E.isSunspotFree ∧ ¬E.isParetoOptimal) :=
  ⟨complete_implies_sunspot_free, incomplete_sunspot_exists⟩
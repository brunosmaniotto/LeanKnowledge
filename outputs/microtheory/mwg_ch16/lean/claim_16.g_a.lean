import Mathlib

variable {Agent : Type*} [Fintype Agent] [Nonempty Agent]
variable {Allocation : Type*}

variable (LindahlEquilibrium : Allocation → Prop)
variable (ParetoOptimal : Allocation → Prop)

theorem lindahl_iff_pareto
    (first_welfare_theorem : ∀ a, LindahlEquilibrium a → ParetoOptimal a)
    (second_welfare_theorem : ∀ a, ParetoOptimal a → LindahlEquilibrium a) :
    ∀ a, LindahlEquilibrium a ↔ ParetoOptimal a := by
  intro a
  exact ⟨first_welfare_theorem a, second_welfare_theorem a⟩
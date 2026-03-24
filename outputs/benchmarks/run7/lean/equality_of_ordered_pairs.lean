import Mathlib

theorem ordered_pair_eq_iff {α β : Type} (a c : α) (b d : β) : (a, b) = (c, d) ↔ a = c ∧ b = d := by
  -- Both directions are provided by existing lemmas:
  -- Forward: `Prod.mk.inj` gives (a,b) = (c,d) → a = c ∧ b = d
  -- Reverse: `Prod.ext` gives a = c → b = d → (a,b) = (c,d)
  exact ⟨Prod.mk.inj, fun ⟨h1, h2⟩ => Prod.ext h1 h2⟩
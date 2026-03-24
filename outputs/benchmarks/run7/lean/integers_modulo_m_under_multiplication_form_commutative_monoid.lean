import Mathlib

theorem integers_mod_m_comm_monoid (m : ℕ) :
    (∀ (a b c : ZMod m), a * b * c = a * (b * c)) ∧
    (∃ (e : ZMod m), ∀ (a : ZMod m), e * a = a ∧ a * e = a) ∧
    (∀ (a b : ZMod m), a * b = b * a) := by
  constructor
  · exact mul_assoc
  constructor
  · refine ⟨1, ?_⟩
    intro a
    exact ⟨one_mul a, mul_one a⟩
  · exact mul_comm
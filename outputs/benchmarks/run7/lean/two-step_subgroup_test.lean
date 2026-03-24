import Mathlib

theorem two_step_subgroup_test {G : Type*} [Group G] (H : Set G) :
    (H.Nonempty ∧ (∀ a b, a ∈ H → b ∈ H → a * b ∈ H) ∧ (∀ a, a ∈ H → a⁻¹ ∈ H)) ↔
    ∃ (K : Subgroup G), (K : Set G) = H := by
  constructor
  · intro ⟨hne, hmul, hinv⟩
    have h_one : 1 ∈ H := by
      rcases hne with ⟨x, hx⟩
      have hxinv : x⁻¹ ∈ H := hinv x hx
      have htemp : x * x⁻¹ ∈ H := hmul x x⁻¹ hx hxinv
      simpa using htemp
    have mul_mem' : ∀ {a b : G}, a ∈ H → b ∈ H → a * b ∈ H := by
      intro a b ha hb
      exact hmul a b ha hb
    have inv_mem' : ∀ {a : G}, a ∈ H → a⁻¹ ∈ H := by
      intro a ha
      exact hinv a ha
    refine ⟨{
        carrier := H
        one_mem' := h_one
        mul_mem' := mul_mem'
        inv_mem' := inv_mem'
      }, rfl⟩
  · intro ⟨K, hK⟩
    rw [← hK]
    refine ⟨⟨1, K.one_mem⟩, ?_, ?_⟩
    · intro a b ha hb
      exact K.mul_mem ha hb
    · intro a ha
      exact K.inv_mem ha
import Mathlib

open Set

theorem exists_order_iso_subset (S : Type u) [PartialOrder S] : ∃ (T : Set (Set S)), Nonempty (S ≃o T) := by
  let T : Set (Set S) := range (Set.Iic : S → Set S)
  let φ : S → T := fun a => ⟨Set.Iic a, a, rfl⟩
  have h_inj : Function.Injective φ := by
    intro a b h
    have h_val : (φ a).val = (φ b).val := congr_arg Subtype.val h
    have ha : a ∈ (φ a).val := mem_Iic.mpr (le_refl a)
    have hb : b ∈ (φ b).val := mem_Iic.mpr (le_refl b)
    rw [h_val] at ha
    have h1 : a ≤ b := mem_Iic.mp ha
    rw [← h_val] at hb
    have h2 : b ≤ a := mem_Iic.mp hb
    exact le_antisymm h1 h2
  have h_surj : Function.Surjective φ := by
    rintro ⟨s, a, rfl⟩
    exact ⟨a, rfl⟩
  let e : S ≃ T := Equiv.ofBijective φ ⟨h_inj, h_surj⟩
  let order_iso : S ≃o T :=
    { e with
      map_rel_iff' := by
        intro a b
        exact Set.Iic_subset_Iic }
  exact ⟨T, ⟨order_iso⟩⟩
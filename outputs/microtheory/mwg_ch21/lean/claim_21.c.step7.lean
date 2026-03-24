import Mathlib
open Topology

variable {I : Type*} [Fintype I] [DecidableEq I]

theorem Claim_21C_Step7
    (decisive : Finset I → Prop)
    (step4 : ∀ S T : Finset I, decisive S → decisive T → decisive (S ∩ T))
    (step5 : ∀ S : Finset I, ¬decisive S → decisive (Finset.univ \ S))
    (S : Finset I)
    (hS_decisive : decisive S)
    (hS_sub : S ⊂ Finset.univ)
    (hS_card : 1 < S.card) :
    ∃ S' : Finset I, S' ≠ ∅ ∧ S' ⊂ S ∧ decisive S' := by
  obtain ⟨h, hh_mem⟩ := Finset.card_pos.mp (by omega : 0 < S.card)
  by_cases h_case : decisive (S.erase h)
  · refine ⟨S.erase h, ?_, Finset.erase_ssubset hh_mem, h_case⟩
    intro h_empty
    have : (S.erase h).card = 0 := by rw [h_empty]; simp
    rw [Finset.card_erase_of_mem hh_mem] at this
    omega
  · have h_comp := step5 (S.erase h) h_case
    have h_inter := step4 S (Finset.univ \ S.erase h) hS_decisive h_comp
    have h_eq : S ∩ (Finset.univ \ S.erase h) = {h} := by
      ext x
      simp only [Finset.mem_inter, Finset.mem_sdiff, Finset.mem_univ, true_and,
                  Finset.mem_erase, Finset.mem_singleton]
      constructor
      · rintro ⟨hxS, hx_not_erase⟩
        by_contra hne
        exact hx_not_erase ⟨hne, hxS⟩
      · rintro rfl
        exact ⟨hh_mem, fun ⟨hne, _⟩ => hne rfl⟩
    rw [h_eq] at h_inter
    refine ⟨{h}, Finset.singleton_ne_empty h, ?_, h_inter⟩
    rw [Finset.ssubset_iff_of_subset (Finset.singleton_subset_iff.mpr hh_mem)]
    have h_erase_nonempty : (S.erase h).Nonempty := by
      rw [Finset.nonempty_iff_ne_empty]
      intro h_empty
      have : (S.erase h).card = 0 := by rw [h_empty]; simp
      rw [Finset.card_erase_of_mem hh_mem] at this
      omega
    obtain ⟨y, hy_mem⟩ := h_erase_nonempty
    rw [Finset.mem_erase] at hy_mem
    exact ⟨y, hy_mem.2, by simp [Finset.mem_singleton]; exact hy_mem.1⟩
import Mathlib
open Topology

variable {I : Type*} [Fintype I] [DecidableEq I] [Nonempty I]

axiom Decisive : Finset I → Prop
axiom DecidableDecisive : ∀ S : Finset I, Decidable (Decisive S)

axiom pareto_decisive : Decisive (Finset.univ (α := I))

axiom step7_split : ∀ S : Finset I, Decisive S → 1 < S.card →
  ∃ T : Finset I, T ⊂ S ∧ Decisive T ∧ T.card < S.card ∧ 0 < T.card

attribute [instance] DecidableDecisive

theorem Claim_21C_Step8 :
    ∃ h : I, Decisive ({h} : Finset I) := by
  suffices ∀ n : ℕ, ∀ S : Finset I, Decisive S → S.card = n → 0 < n →
      ∃ h : I, h ∈ S ∧ Decisive ({h} : Finset I) by
    obtain ⟨h, _, hd⟩ := this _ (Finset.univ (α := I)) pareto_decisive rfl
      (Finset.card_pos.mpr ⟨Classical.arbitrary I, Finset.mem_univ _⟩)
    exact ⟨h, hd⟩
  intro n
  induction n using Nat.strongRecOn with
  | ind n ih =>
    intro S hDS hcard hpos
    by_cases h1 : S.card ≤ 1
    · have hone : S.card = 1 := by omega
      rw [Finset.card_eq_one] at hone
      obtain ⟨a, ha⟩ := hone
      exact ⟨a, ha ▸ Finset.mem_singleton_self a, ha ▸ hDS⟩
    · push_neg at h1
      obtain ⟨T, hTS, hDT, hlt, hTpos⟩ := step7_split S hDS h1
      obtain ⟨h, hT, hDh⟩ := ih T.card (by omega) T hDT rfl hTpos
      exact ⟨h, Finset.mem_of_subset hTS.subset hT, hDh⟩
import Mathlib
open Topology

private lemma rtc_cases_head {α : Type*} {r : α → α → Prop} {a b : α}
    (h : Relation.ReflTransGen r a b) :
    a = b ∨ ∃ c, r a c ∧ Relation.ReflTransGen r c b := by
  induction h with
  | refl => left; rfl
  | tail _hab hmb ih =>
    rcases ih with rfl | ⟨c, hac, hcm⟩
    · right; exact ⟨_, hmb, .refl⟩
    · right; exact ⟨c, hac, hcm.tail hmb⟩

theorem iesds_order_independent
    {α : Type*}
    (r : α → α → Prop)
    (wf : WellFounded (fun a b => r b a))
    (lc : ∀ a b c, r a b → r a c →
      ∃ d, Relation.ReflTransGen r b d ∧ Relation.ReflTransGen r c d)
    {a b c : α}
    (hab : Relation.ReflTransGen r a b)
    (hac : Relation.ReflTransGen r a c)
    (hb : ∀ x, ¬ r b x)
    (hc : ∀ x, ¬ r c x) :
    b = c := by
  suffices conf : ∀ x y z, Relation.ReflTransGen r x y → Relation.ReflTransGen r x z →
      ∃ w, Relation.ReflTransGen r y w ∧ Relation.ReflTransGen r z w by
    obtain ⟨w, hbw, hcw⟩ := conf a b c hab hac
    rcases rtc_cases_head hbw with rfl | ⟨t, ht, _⟩
    · rcases rtc_cases_head hcw with rfl | ⟨t, ht, _⟩
      · rfl
      · exact absurd ht (hc t)
    · exact absurd ht (hb t)
  intro x
  induction x using wf.induction with
  | h x ih =>
    intro y z hxy hxz
    rcases rtc_cases_head hxy with rfl | ⟨b₁, hxb₁, hb₁y⟩
    · exact ⟨z, hxz, .refl⟩
    · rcases rtc_cases_head hxz with rfl | ⟨c₁, hxc₁, hc₁z⟩
      · exact ⟨y, .refl, Relation.ReflTransGen.head hxb₁ hb₁y⟩
      · obtain ⟨d, hb₁d, hc₁d⟩ := lc x b₁ c₁ hxb₁ hxc₁
        obtain ⟨w₁, hyw₁, hdw₁⟩ := ih b₁ hxb₁ y d hb₁y hb₁d
        obtain ⟨w₂, hzw₂, hw₁w₂⟩ := ih c₁ hxc₁ z w₁ hc₁z (hc₁d.trans hdw₁)
        exact ⟨w₂, hyw₁.trans hw₁w₂, hzw₂⟩
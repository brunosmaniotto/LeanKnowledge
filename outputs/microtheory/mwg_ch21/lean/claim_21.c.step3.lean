import Mathlib
open Topology
open Finset

theorem Claim_21C_Step3
    {X : Type*} [Fintype X] [DecidableEq X]
    (hX : 3 ≤ Fintype.card X)
    {I : Type*}
    (decisive : Set I → X → X → Prop)
    (step2_ac : ∀ S : Set I, ∀ a b c : X, a ≠ b → a ≠ c → b ≠ c → decisive S a b → decisive S a c)
    (step2_cb : ∀ S : Set I, ∀ a b c : X, a ≠ b → a ≠ c → b ≠ c → decisive S a b → decisive S c b)
    (step1 : ∀ S : Set I, ∀ a b c : X, a ≠ b → a ≠ c → b ≠ c → decisive S a c → decisive S c b → decisive S a b)
    (S : Set I) (x y : X) (hxy : x ≠ y)
    (hSxy : decisive S x y) :
    ∀ v w : X, v ≠ w → decisive S v w := by
  have ⟨z, hzx, hzy⟩ : ∃ z : X, z ≠ x ∧ z ≠ y := by
    by_contra h; push_neg at h
    have : Fintype.card X ≤ 2 := by
      have hsub : (Finset.univ : Finset X) ⊆ {x, y} := by
        intro a _
        simp only [Finset.mem_insert, Finset.mem_singleton]
        by_contra hc; push_neg at hc
        exact absurd (h a hc.1) hc.2
      calc Fintype.card X = Finset.card Finset.univ := (Finset.card_univ).symm
        _ ≤ Finset.card {x, y} := Finset.card_le_card hsub
        _ ≤ 2 := by rw [Finset.card_pair hxy]
    omega
  have hxz : decisive S x z := step2_ac S x y z hxy hzx.symm hzy.symm hSxy
  have hzy' : decisive S z y := step2_cb S x y z hxy hzx.symm hzy.symm hSxy
  have h_az : ∀ a : X, a ≠ z → decisive S a z := by
    intro a haz
    by_cases hax : a = x
    · rw [hax]; exact hxz
    by_cases hay : a = y
    · rw [hay]
      exact step2_cb S x z y hzx.symm hxy hzy hxz
    · exact step2_ac S a y z (fun h => hay h) haz hzy.symm
        (step2_cb S x y a hxy (fun h => hax h.symm) (fun h => hay h.symm) hSxy)
  have h_zb : ∀ b : X, b ≠ z → decisive S z b := by
    intro b hbz
    by_cases hbx : b = x
    · rw [hbx]; exact step2_ac S z y x hzy hzx hxy.symm hzy'
    by_cases hby : b = y
    · rw [hby]; exact hzy'
    · exact step2_ac S z y b hzy (fun h => hbz h.symm) (fun h => hby h.symm) hzy'
  intro v w hvw
  by_cases hvz : v = z
  · rw [hvz]; exact h_zb w (fun h => hvw (hvz ▸ h.symm))
  by_cases hwz : w = z
  · rw [hwz]; exact h_az v hvz
  · exact step1 S v w z hvw hvz hwz (h_az v hvz) (h_zb w hwz)
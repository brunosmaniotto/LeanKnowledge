import Mathlib
open Topology

variable {n : ℕ}
abbrev Bndl (n : ℕ) := Fin n → ℝ

structure URep (n : ℕ) where
  u : Bndl n → ℝ
  pref : Bndl n → Bndl n → Prop
  rep : ∀ x y, pref x y ↔ u x ≥ u y

noncomputable def combo (a : ℝ) (x y : Bndl n) : Bndl n :=
  fun i => a * x i + (1 - a) * y i

theorem theorem_1_3 (R : URep n) :
    -- (1) strictly increasing ↔ strictly monotonic
    ((∀ x y : Bndl n, (∀ i, x i ≥ y i) → x ≠ y → R.u x > R.u y) ↔
     (∀ x y : Bndl n, (∀ i, x i ≥ y i) → x ≠ y → R.pref x y ∧ ¬R.pref y x)) ∧
    -- (2) quasiconcave ↔ convex
    ((∀ x y : Bndl n, ∀ a : ℝ, 0 ≤ a → a ≤ 1 →
      R.u (combo a x y) ≥ min (R.u x) (R.u y)) ↔
     (∀ z x y : Bndl n, R.pref x z → R.pref y z → ∀ a : ℝ, 0 ≤ a → a ≤ 1 →
      R.pref (combo a x y) z)) ∧
    -- (3) strictly quasiconcave ↔ strictly convex
    ((∀ x y : Bndl n, x ≠ y → ∀ a : ℝ, 0 < a → a < 1 →
      R.u (combo a x y) > min (R.u x) (R.u y)) ↔
     (∀ z x y : Bndl n, R.pref x z → R.pref y z → x ≠ y → ∀ a : ℝ, 0 < a → a < 1 →
      R.pref (combo a x y) z ∧ ¬R.pref z (combo a x y))) := by
  refine ⟨⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩⟩
  · -- (1) →
    intro h x y hge hne; have hgt := h x y hge hne
    exact ⟨(R.rep x y).mpr hgt.le, fun h' => by linarith [(R.rep y x).mp h']⟩
  · -- (1) ←
    intro h x y hge hne; obtain ⟨_, hnp⟩ := h x y hge hne
    by_contra hle; push_neg at hle; exact hnp ((R.rep y x).mpr hle)
  · -- (2) →
    intro h z x y hxz hyz a ha0 ha1; rw [R.rep] at hxz hyz ⊢
    linarith [h x y a ha0 ha1, le_min hxz hyz]
  · -- (2) ←
    intro h x y a ha0 ha1
    rcases le_total (R.u x) (R.u y) with hle | hle
    · rw [min_eq_left hle, ← R.rep]
      exact h x x y ((R.rep x x).mpr le_rfl) ((R.rep y x).mpr hle) a ha0 ha1
    · rw [min_eq_right hle, ← R.rep]
      exact h y x y ((R.rep x y).mpr hle) ((R.rep y y).mpr le_rfl) a ha0 ha1
  · -- (3) →
    intro h z x y hxz hyz hne a ha0 ha1; rw [R.rep] at hxz hyz
    have hgt : R.u (combo a x y) > R.u z := by
      linarith [h x y hne a ha0 ha1, le_min hxz hyz]
    exact ⟨(R.rep _ z).mpr hgt.le, fun h' => by linarith [(R.rep z _).mp h']⟩
  · -- (3) ←
    intro h x y hne a ha0 ha1
    rcases le_total (R.u x) (R.u y) with hle | hle
    · rw [min_eq_left hle]; obtain ⟨_, hnp⟩ :=
        h x x y ((R.rep x x).mpr le_rfl) ((R.rep y x).mpr hle) hne a ha0 ha1
      rw [R.rep] at hnp; push_neg at hnp; exact hnp
    · rw [min_eq_right hle]; obtain ⟨_, hnp⟩ :=
        h y x y ((R.rep x y).mpr hle) ((R.rep y y).mpr le_rfl) hne a ha0 ha1
      rw [R.rep] at hnp; push_neg at hnp; exact hnp
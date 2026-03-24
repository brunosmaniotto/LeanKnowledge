import Mathlib

noncomputable section

structure RamseySolowModel where
  F : ℝ → ℝ
  u : ℝ → ℝ
  u' : ℝ → ℝ
  F' : ℝ → ℝ
  δ : ℝ

theorem Example_20D2 (m : RamseySolowModel)
    (k : ℕ → ℝ)
    (c : ℕ → ℝ)
    (hc : ∀ t, c t = m.F (k (t - 1)) - k t)
    (hEuler : ∀ t ≥ 1, -m.u' (m.F (k (t - 1)) - k t)
      + m.δ * m.u' (m.F (k t) - k (t + 1)) * m.F' (k t) = 0)
    (hpos : ∀ t, m.u' (c t) > 0)
    (t : ℕ) (ht : t ≥ 1) :
    m.u' (c t) / m.u' (c (t + 1)) = m.δ * m.F' (k t) := by
  have hE := hEuler t ht
  have hpos_t1 := hpos (t + 1)
  rw [hc (t + 1)] at hpos_t1
  have hsub : t + 1 - 1 = t := Nat.succ_sub_one t
  rw [hsub] at hpos_t1
  rw [hc t, hc (t + 1), hsub]
  have hne : m.u' (m.F (k t) - k (t + 1)) ≠ 0 := ne_of_gt hpos_t1
  rw [div_eq_iff hne]
  nlinarith
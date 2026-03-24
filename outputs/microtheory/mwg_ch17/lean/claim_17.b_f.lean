import Mathlib
open Topology

theorem production_set_crs_properties
    {n : ℕ} (Y : Set (Fin n → ℝ))
    (cone : ∀ y ∈ Y, ∀ t : ℝ, 0 ≤ t → t • y ∈ Y)
    (nontrivial : ∃ y ∈ Y, y ≠ 0) :
    (∃ a ∈ Y, ∃ b ∈ Y, a ≠ b ∧ (1/2 : ℝ) • a + (1/2 : ℝ) • b ∈ Y ∧
      ∀ t : ℝ, 0 ≤ t → t • ((1/2 : ℝ) • a + (1/2 : ℝ) • b) ∈ Y) ∧
    (∀ M : ℝ, ∃ z ∈ Y, M < ‖z‖) := by
  obtain ⟨y, hy, hy_ne⟩ := nontrivial
  have h0 : (0 : ℝ) • y ∈ Y := cone y hy 0 (le_refl 0)
  simp at h0
  have h2 : (2 : ℝ) • y ∈ Y := cone y hy 2 (by norm_num)
  constructor
  · refine ⟨0, h0, (2 : ℝ) • y, h2, ?_, ?_, ?_⟩
    · intro heq
      have : ∀ i, (2 : ℝ) * y i = 0 := fun i => by
        have := congr_fun heq i
        simp [Pi.smul_apply, smul_eq_mul] at this
        linarith
      have : ∀ i, y i = 0 := fun i => by
        have := this i
        linarith
      exact hy_ne (funext this)
    · convert hy using 1
      ext i
      simp [Pi.add_apply]
    · intro t ht
      have : t • ((1 / 2 : ℝ) • (0 : Fin n → ℝ) + (1 / 2 : ℝ) • (2 : ℝ) • y) = t • y := by
        ext i
        simp [Pi.smul_apply, smul_eq_mul]
      rw [this]
      exact cone y hy t ht
  · intro M
    have : ∃ i, y i ≠ 0 := by
      by_contra h
      push_neg at h
      exact hy_ne (funext (fun i => h i))
    obtain ⟨i, hi⟩ := this
    set t := (|M| + 1) / |y i| with ht_def
    have hyi_pos : 0 < |y i| := abs_pos.mpr hi
    have ht_pos : 0 < t := div_pos (by linarith [abs_nonneg M]) hyi_pos
    refine ⟨t • y, cone y hy t (le_of_lt ht_pos), ?_⟩
    calc M ≤ |M| := le_abs_self M
      _ < |M| + 1 := by linarith
      _ = t * |y i| := by rw [ht_def]; field_simp
      _ = |t * y i| := by rw [abs_mul, abs_of_pos ht_pos]
      _ = |((t • y) : Fin n → ℝ) i| := by simp [Pi.smul_apply, smul_eq_mul]
      _ ≤ ‖t • y‖ := by
          apply le_trans _ (norm_le_pi_norm (t • y) i)
          exact le_of_eq rfl
import Mathlib

theorem backwards_induction (P : ℕ → Prop) (h1 : ∀ n, P (2 ^ n)) (h2 : ∀ n, P n → P (n - 1)) : ∀ n, P n := by
  classical
  -- First, prove that for every natural number k, k < 2^k.
  have h_pow_gt : ∀ k, k < 2 ^ k := by
    intro k
    induction' k with k IH
    · norm_num
    · have h_pos : 0 < 2 ^ k := pow_pos (by norm_num) k
      have h_succ : k + 1 ≤ 2 ^ k := by omega
      calc
        k + 1 ≤ 2 ^ k := h_succ
        _ < 2 ^ k + 2 ^ k := by linarith
        _ = 2 ^ (k + 1) := by ring

  -- Now assume for contradiction that there exists an n such that ¬P n.
  by_contra h_not_all
  push_neg at h_not_all
  obtain ⟨k, hk⟩ := h_not_all

  set M := 2 ^ k with hM_def
  have hk_lt : k < M := by
    dsimp [M]
    exact h_pow_gt k

  -- Define S as the set of n < M for which P n is false.
  let S : Finset ℕ := (Finset.range M).filter (¬P ·)

  -- S is nonempty because it contains k.
  have hS_nonempty : S.Nonempty := by
    refine ⟨k, ?_⟩
    rw [Finset.mem_filter]
    exact ⟨Finset.mem_range.mpr hk_lt, hk⟩

  -- Let m be the maximum element of S.
  set m := S.max' hS_nonempty with hm_def
  have hm_mem : m ∈ S := Finset.max'_mem _ hS_nonempty
  obtain ⟨hm_range, hm_not_P⟩ := Finset.mem_filter.1 hm_mem
  have hm_bound : m < M := Finset.mem_range.1 hm_range

  -- Now consider m+1.
  by_cases h : m + 1 < M
  · -- Case 1: m+1 < M. Then by maximality of m, we must have P (m+1).
    have hP_m1 : P (m + 1) := by
      by_contra h_not
      have hm1_mem : m + 1 ∈ S := by
        rw [Finset.mem_filter]
        exact ⟨Finset.mem_range.mpr h, h_not⟩
      have h_le : m + 1 ≤ m := Finset.le_max' S (m + 1) hm1_mem
      omega
    have h2m1 : P ((m + 1) - 1) := h2 (m + 1) hP_m1
    have : (m + 1) - 1 = m := by omega
    rw [this] at h2m1
    exact hm_not_P h2m1
  · -- Case 2: m+1 = M. Then P (m+1) by h1.
    have h_eq : m + 1 = M := by omega
    have hP_m1 : P (m + 1) := by
      rw [h_eq, hM_def]
      exact h1 k
    have h2m1 : P ((m + 1) - 1) := h2 (m + 1) hP_m1
    have : (m + 1) - 1 = m := by omega
    rw [this] at h2m1
    exact hm_not_P h2m1
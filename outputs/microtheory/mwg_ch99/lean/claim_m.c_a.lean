import Mathlib

open BigOperators Finset
open Topology

theorem Claim_M_C_a {N : ℕ} (A : Set (EuclideanSpace ℝ (Fin N)))
    (hA : Convex ℝ A) (f : EuclideanSpace ℝ (Fin N) → ℝ) :
    ConcaveOn ℝ A f ↔
      (∀ (K : ℕ) (x : Fin K → EuclideanSpace ℝ (Fin N))
        (α : Fin K → ℝ),
        (∀ k, x k ∈ A) →
        (∀ k, 0 ≤ α k) →
        ∑ k, α k = 1 →
        f (∑ k, α k • x k) ≥ ∑ k, α k * f (x k)) := by
  constructor
  · intro hf K x α hx hα hsum
    induction K with
    | zero => simp at hsum
    | succ n ih =>
      by_cases hzero : ∑ k : Fin n, α (Fin.castSucc k) = 0
      · have hrest : ∀ k : Fin n, α (Fin.castSucc k) = 0 :=
          fun k => (sum_eq_zero_iff_of_nonneg (fun i _ => hα (Fin.castSucc i))).mp
            hzero k (mem_univ _)
        have hlast : α (Fin.last n) = 1 := by
          have h := Fin.sum_univ_castSucc (n := n) α
          rw [show ∑ k : Fin n, α (Fin.castSucc k) = 0 from
            sum_eq_zero (fun k _ => hrest k)] at h
          linarith
        simp only [Fin.sum_univ_castSucc]
        rw [show ∑ k : Fin n, α (Fin.castSucc k) • x (Fin.castSucc k) = 0 from
          sum_eq_zero (fun k _ => by rw [hrest k]; simp)]
        rw [show ∑ k : Fin n, α (Fin.castSucc k) * f (x (Fin.castSucc k)) = 0 from
          sum_eq_zero (fun k _ => by rw [hrest k]; simp)]
        simp [hlast]
      · set t := ∑ k : Fin n, α (Fin.castSucc k) with ht_def
        have ht_pos : 0 < t :=
          lt_of_le_of_ne (sum_nonneg (fun k _ => hα (Fin.castSucc k))) (Ne.symm hzero)
        have ht_ne : t ≠ 0 := ne_of_gt ht_pos
        have halast : α (Fin.last n) = 1 - t := by
          have := Fin.sum_univ_castSucc (n := n) α; linarith
        have ht_le_one : t ≤ 1 := by linarith [hα (Fin.last n)]
        have h1mt_nn : 0 ≤ 1 - t := by linarith
        set β : Fin n → ℝ := fun k => α (Fin.castSucc k) / t
        have hβ_nn : ∀ k, 0 ≤ β k := fun k => div_nonneg (hα _) (le_of_lt ht_pos)
        have hβ_sum : ∑ k, β k = 1 := by
          simp only [β, ← sum_div]; exact div_self ht_ne
        set y := ∑ k : Fin n, β k • x (Fin.castSucc k)
        have hy_mem : y ∈ A :=
          hA.sum_mem (fun k _ => hβ_nn k) hβ_sum (fun k _ => hx _)
        have hy_eq : t • y = ∑ k : Fin n, α (Fin.castSucc k) • x (Fin.castSucc k) := by
          simp only [y, β, smul_sum, smul_smul]
          apply sum_congr rfl; intro k _; congr 1; field_simp
        have hfy : f y ≥ ∑ k : Fin n, β k * f (x (Fin.castSucc k)) :=
          ih (fun k => x (Fin.castSucc k)) β (fun k => hx _) hβ_nn hβ_sum
        have sum_eq : t * (∑ k : Fin n, β k * f (x (Fin.castSucc k))) =
            ∑ k : Fin n, α (Fin.castSucc k) * f (x (Fin.castSucc k)) := by
          rw [mul_sum]; apply sum_congr rfl; intro k _; simp only [β]; field_simp
        simp only [Fin.sum_univ_castSucc]
        calc f (∑ k : Fin n, α (Fin.castSucc k) • x (Fin.castSucc k) +
                α (Fin.last n) • x (Fin.last n))
            = f (t • y + (1 - t) • x (Fin.last n)) := by rw [halast, ← hy_eq]
          _ ≥ t * f y + (1 - t) * f (x (Fin.last n)) :=
              hf.2 hy_mem (hx (Fin.last n)) (le_of_lt ht_pos) h1mt_nn (by linarith)
          _ ≥ t * (∑ k : Fin n, β k * f (x (Fin.castSucc k))) +
              (1 - t) * f (x (Fin.last n)) := by
              linarith [mul_le_mul_of_nonneg_left hfy (le_of_lt ht_pos)]
          _ = ∑ k : Fin n, α (Fin.castSucc k) * f (x (Fin.castSucc k)) +
              α (Fin.last n) * f (x (Fin.last n)) := by rw [sum_eq, halast]
  · intro hf
    refine ⟨hA, fun x hx y hy a b ha hb hab => ?_⟩
    have h := hf 2 (![x, y]) (![a, b])
      (by intro k; fin_cases k <;> simp_all [Matrix.cons_val_zero, Matrix.cons_val_one])
      (by intro k; fin_cases k <;> simp_all [Matrix.cons_val_zero, Matrix.cons_val_one])
      (by simp [Fin.sum_univ_two, Matrix.cons_val_zero, Matrix.cons_val_one, hab])
    simp only [Fin.sum_univ_two, Matrix.cons_val_zero, Matrix.cons_val_one] at h
    -- h : f (a • x + b • y) ≥ a * f x + b * f y
    -- goal : a • f x + b • f y ≤ f (a • x + b • y)
    -- In ℝ, • is the same as *, so we just need to convert
    simp only [smul_eq_mul]
    linarith
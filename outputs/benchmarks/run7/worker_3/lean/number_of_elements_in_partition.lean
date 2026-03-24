import Mathlib

variable {α : Type} [DecidableEq α]

theorem card_partition (S : Finset α) (P : Finset (Finset α)) (n m : ℕ)
    (hP : P.card = n) (hsize : ∀ t ∈ P, t.card = m)
    (hdisj : ∀ t1 ∈ P, ∀ t2 ∈ P, t1 ≠ t2 → Disjoint t1 t2)
    (hcover : P.biUnion id = S) : S.card = n * m := by
  calc
    S.card = (P.biUnion id).card := by rw [hcover]
    _ = ∑ t ∈ P, (id t).card := by
      rw [Finset.card_biUnion]
      intro t1 ht1 t2 ht2 hne
      exact hdisj t1 ht1 t2 ht2 hne
    _ = ∑ t ∈ P, t.card := by simp
    _ = ∑ t ∈ P, m := Finset.sum_congr rfl (fun t ht => by rw [hsize t ht])
    _ = P.card • m := by rw [Finset.sum_const]
    _ = P.card * m := by rw [Nat.nsmul_eq_mul]
    _ = n * m := by rw [hP]
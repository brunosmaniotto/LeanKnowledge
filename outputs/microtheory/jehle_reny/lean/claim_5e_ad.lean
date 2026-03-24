import Mathlib

open BigOperators Finset
open Topology

theorem Claim_5e_ad
    {S K : ℕ}
    (p x e : Fin S → Fin K → ℝ) :
    (∑ s : Fin S, ∑ k : Fin K, p s k * x s k =
     ∑ s : Fin S, ∑ k : Fin K, p s k * e s k) ↔
    (∃ a : Fin S → ℝ, (∑ s : Fin S, a s = 0) ∧
      ∀ s : Fin S, ∑ k : Fin K, p s k * x s k =
        (∑ k : Fin K, p s k * e s k) + a s) := by
  constructor
  · intro h
    refine ⟨fun s => ∑ k, p s k * x s k - ∑ k, p s k * e s k, ?_, fun s => by ring⟩
    simp only [sub_eq_add_neg, Finset.sum_add_distrib, Finset.sum_neg_distrib]
    linarith
  · rintro ⟨a, ha_sum, ha_spot⟩
    have hcong := Finset.sum_congr rfl (fun (s : Fin S) (_ : s ∈ Finset.univ) => ha_spot s)
    rw [hcong, Finset.sum_add_distrib, ha_sum, add_zero]
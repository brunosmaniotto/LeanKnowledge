import Mathlib

theorem preimage_subring_and_ker_subset {R S : Type _} [Ring R] [Ring S] (φ : R →+* S) (T : Subring S) :
    (RingHom.ker φ : Set R) ⊆ (Subring.comap φ T : Set R) := by
  intro x hx
  apply Subring.mem_comap.2
  have h := RingHom.mem_ker.1 hx
  rw [h]
  exact T.zero_mem
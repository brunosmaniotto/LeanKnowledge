import Mathlib

variable {R M : Type*} [Ring R] [AddCommGroup M] [Module R M]

theorem submodule_iff (H : Set M) (hHne : H.Nonempty) :
    (∃ S : Submodule R M, (S : Set M) = H) ↔
    (∀ x y, x ∈ H → y ∈ H → x + y ∈ H) ∧ (∀ (c : R) x, x ∈ H → c • x ∈ H) := by
  constructor
  · rintro ⟨S, rfl⟩
    constructor
    · intro x y hx hy
      exact S.add_mem hx hy
    · intro c x hx
      exact S.smul_mem c hx
  · rintro ⟨h_add, h_smul⟩
    have zero_mem : (0 : M) ∈ H := by
      obtain ⟨x, hx⟩ := hHne
      have h0 : (0 : R) • x ∈ H := h_smul 0 x hx
      rwa [zero_smul] at h0
    refine ⟨{
      carrier := H
      zero_mem' := zero_mem
      add_mem' := fun {x y} hx hy => h_add x y hx hy
      smul_mem' := fun c {x} hx => h_smul c x hx
    }, rfl⟩
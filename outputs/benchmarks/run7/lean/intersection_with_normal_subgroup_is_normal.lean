import Mathlib

theorem intersection_normal_subgroup (G : Type*) [Group G] (H : Subgroup G) (N : Subgroup G)
    [hN : N.Normal] : ((H ⊓ N).subgroupOf H).Normal := by
  constructor
  intro n hn g
  -- `hn` gives that `n` (as an element of `G`) is in `H ⊓ N`
  have h_mem : (n : G) ∈ H ⊓ N := hn
  have hH : (n : G) ∈ H := h_mem.1
  have hNmem : (n : G) ∈ N := h_mem.2
  have gH : (g : G) ∈ H := g.2
  -- Conjugate is in `H` because `H` is a subgroup
  have conj_mem_H : (g * n * g⁻¹ : G) ∈ H :=
    H.mul_mem (H.mul_mem gH hH) (H.inv_mem gH)
  -- Conjugate is in `N` by normality of `N` in `G`
  have conj_mem_N : (g * n * g⁻¹ : G) ∈ N :=
    hN.conj_mem (n : G) hNmem (g : G)
  -- Therefore, the conjugate is in `H ⊓ N`
  have h_conj : (g * n * g⁻¹ : G) ∈ H ⊓ N := ⟨conj_mem_H, conj_mem_N⟩
  -- By definition of `subgroupOf`, this means `g * n * g⁻¹` (as an element of `H`) is in `(H ⊓ N).subgroupOf H`
  exact Subgroup.mem_subgroupOf.mpr h_conj
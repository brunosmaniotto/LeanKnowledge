import Mathlib

open Finset BigOperators
open Topology
open BigOperators

noncomputable section

theorem lagrange_multiplier_theorem
    {N M : ℕ}
    (grad_f : Fin N → ℝ)
    (grad_g : Fin M → Fin N → ℝ)
    (null_space_condition : ∀ z : Fin N → ℝ,
      (∀ m : Fin M, ∑ n : Fin N, grad_g m n * z n = 0) →
      ∑ n : Fin N, grad_f n * z n = 0) :
    ∃ mu : Fin M → ℝ, ∀ n : Fin N,
      grad_f n = ∑ m : Fin M, mu m * grad_g m n := by
  let A : (Fin N → ℝ) →ₗ[ℝ] (Fin M → ℝ) :=
    { toFun := fun z m => ∑ n, grad_g m n * z n
      map_add' := by intro x y; ext m; simp [Finset.sum_add_distrib, mul_add]
      map_smul' := by intro r x; ext m; simp [Finset.mul_sum, mul_left_comm] }
  let phi : (Fin N → ℝ) →ₗ[ℝ] ℝ :=
    { toFun := fun z => ∑ n, grad_f n * z n
      map_add' := by intro x y; simp [Finset.sum_add_distrib, mul_add]
      map_smul' := by intro r x; simp [Finset.mul_sum, mul_left_comm] }
  have h_ker : LinearMap.ker A ≤ LinearMap.ker phi := by
    intro z hz
    simp only [LinearMap.mem_ker] at hz ⊢
    exact null_space_condition z (fun m => by have := congr_fun hz m; simpa using this)
  have h_phi_in_range : phi ∈ LinearMap.range (A.dualMap : ((Fin M → ℝ) →ₗ[ℝ] ℝ) →ₗ[ℝ] ((Fin N → ℝ) →ₗ[ℝ] ℝ)) := by
    rw [LinearMap.range_dualMap_eq_dualAnnihilator_ker]
    rw [Submodule.mem_dualAnnihilator]
    intro z hz
    exact (LinearMap.mem_ker.mp (h_ker hz))
  obtain ⟨psi, hpsi⟩ := h_phi_in_range
  let c : Fin M → ℝ := fun m => psi (Pi.single m (1 : ℝ) : Fin M → ℝ)
  refine ⟨c, fun n => ?_⟩
  have h_eq : (A.dualMap psi) (Pi.single n (1 : ℝ)) = phi (Pi.single n (1 : ℝ)) := by
    rw [hpsi]
  simp only [LinearMap.dualMap_apply] at h_eq
  have h_phi : phi (Pi.single n (1 : ℝ)) = grad_f n := by
    simp [phi, Pi.single_apply, Finset.sum_ite_eq', Finset.mem_univ]
  have h_A : A (Pi.single n (1 : ℝ)) = fun m => grad_g m n := by
    ext m
    simp [A, Pi.single_apply, Finset.sum_ite_eq', Finset.mem_univ]
  have h_psi : psi (fun m => grad_g m n) = ∑ m, c m * grad_g m n := by
    have decomp : (fun m : Fin M => grad_g m n) =
        ∑ m : Fin M, grad_g m n • (Pi.single m (1 : ℝ) : Fin M → ℝ) := by
      ext i
      simp [Finset.sum_apply, Pi.smul_apply, Pi.single_apply, smul_eq_mul,
            Finset.sum_ite_eq', Finset.mem_univ]
    rw [decomp, map_sum]
    congr 1; ext m
    rw [LinearMap.map_smul, smul_eq_mul, mul_comm]
  linarith [h_eq, h_phi,
    (show psi (A (Pi.single n (1 : ℝ))) = psi (fun m => grad_g m n) by rw [h_A])]
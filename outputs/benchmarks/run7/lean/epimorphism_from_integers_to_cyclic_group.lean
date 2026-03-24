import Mathlib

open Subgroup

theorem epimorphism_from_integers (G : Type*) [Group G] (a : G) (h : zpowers a = ⊤) :
    let f : ℤ → G := fun n => a ^ n; f 0 = 1 ∧ (∀ n m : ℤ, f (n + m) = f n * f m) ∧ Function.Surjective f := by
  intro f
  have f0 : f 0 = 1 := by simp [f]
  have fadd : ∀ n m : ℤ, f (n + m) = f n * f m := by
    intro n m
    simp [f, zpow_add]
  have surj : Function.Surjective f := by
    intro x
    have hx : x ∈ zpowers a := by rw [h]; exact mem_top x
    rcases mem_zpowers_iff.mp hx with ⟨n, rfl⟩
    exact ⟨n, rfl⟩
  exact ⟨f0, fadd, surj⟩
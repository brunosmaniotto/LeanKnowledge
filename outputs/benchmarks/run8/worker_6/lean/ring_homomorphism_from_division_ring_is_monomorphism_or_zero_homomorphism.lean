import Mathlib

variable {R S : Type*} [DivisionRing R] [Ring S] (φ : R →+* S)

theorem Ring_Homomorphism_from_Division_Ring_is_Monomorphism_or_Zero_Homomorphism :
  Function.Injective φ ∨ (∀ a : R, φ a = 0) := by
  -- The kernel of φ is an ideal of the division ring R.
  -- In a division ring, any ideal is either the bottom ideal {0} or the top ideal (the whole ring).
  have h_ker_cases : RingHom.ker φ = ⊥ ∨ RingHom.ker φ = ⊤ :=
    Ideal.eq_bot_or_top (RingHom.ker φ)

  -- We proceed by cases on the kernel.
  rcases h_ker_cases with h_ker_bot | h_ker_top

  -- Case 1: The kernel is the bottom ideal {0}.
  · left
    -- In this case, the homomorphism is injective.
    -- This is exactly the content of `RingHom.injective_iff_ker_eq_bot`.
    rwa [RingHom.injective_iff_ker_eq_bot]

  -- Case 2: The kernel is the top ideal, i.e., the whole ring R.
  · right
    -- In this case, the homomorphism is the zero homomorphism.
    intro a
    -- We need to show that φ maps any element 'a' to 0.
    -- This is equivalent to 'a' being in the kernel of φ.
    rw [← RingHom.mem_ker]
    -- Now use the fact that the kernel is the whole ring.
    rw [h_ker_top]
    -- Any element 'a' is in the top ideal.
    exact Submodule.mem_top
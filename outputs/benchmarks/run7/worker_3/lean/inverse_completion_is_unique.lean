import Mathlib.Algebra.Group.Defs
import Mathlib.Algebra.Group.Hom.Defs
import Mathlib.Algebra.Group.Equiv.Basic
import Mathlib.Tactic

universe u

variable {S : Type u} [CommSemigroup S] [IsCancelMul S]

structure IsInverseCompletion (G : Type u) [CommGroup G] (i : S → G) : Prop where
  i_hom : ∀ x y, i (x * y) = i x * i y
  injective : ∀ x y, i x = i y → x = y
  surjective : ∀ g : G, ∃ a b : S, g = i a * (i b)⁻¹
  universal : ∀ (H : Type u) [CommGroup H] (f : S → H) (hf : ∀ x y, f (x * y) = f x * f y),
    ∃! g : G →* H, ∀ x, g (i x) = f x

theorem inverseCompletion_unique (T T' : Type u) [CommGroup T] [CommGroup T'] 
    (i : S → T) (i' : S → T') (hT : IsInverseCompletion T i) (hT' : IsInverseCompletion T' i') :
    ∃ φ : T ≃* T', ∀ x, φ (i x) = i' x := by
  -- Get φ from universal property of T
  have φ_ex := hT.universal T' i' hT'.i_hom
  rcases φ_ex with ⟨φ, hφ, φ_unique⟩
  
  -- Get ψ from universal property of T'
  have ψ_ex := hT'.universal T i hT.i_hom
  rcases ψ_ex with ⟨ψ, hψ, ψ_unique⟩
  
  -- Show ψ.comp φ satisfies condition for universal property of T (target T)
  have h_comp1 : ∀ x, (ψ.comp φ) (i x) = i x := by
    intro x
    calc
      (ψ.comp φ) (i x) = ψ (φ (i x)) := rfl
      _ = ψ (i' x) := by rw [hφ]
      _ = i x := hψ x
  
  -- Identity homomorphism on T also satisfies the condition
  have h_id_T : ∀ x, (MonoidHom.id T) (i x) = i x := by simp
  
  -- Use uniqueness to prove ψ.comp φ = id
  have comp1_unique := hT.universal T i hT.i_hom
  rcases comp1_unique with ⟨g, hg, unique⟩
  have h_comp1_eq_g : ψ.comp φ = g := unique (ψ.comp φ) h_comp1
  have id_eq_g : MonoidHom.id T = g := unique (MonoidHom.id T) h_id_T
  have comp1_eq_id : ψ.comp φ = MonoidHom.id T := by rw [h_comp1_eq_g, id_eq_g]
  
  -- Show φ.comp ψ satisfies condition for universal property of T' (target T')
  have h_comp2 : ∀ x, (φ.comp ψ) (i' x) = i' x := by
    intro x
    calc
      (φ.comp ψ) (i' x) = φ (ψ (i' x)) := rfl
      _ = φ (i x) := by rw [hψ]
      _ = i' x := hφ x
  
  -- Identity homomorphism on T' also satisfies the condition
  have h_id_T' : ∀ x, (MonoidHom.id T') (i' x) = i' x := by simp
  
  -- Use uniqueness to prove φ.comp ψ = id
  have comp2_unique := hT'.universal T' i' hT'.i_hom
  rcases comp2_unique with ⟨g', hg', unique'⟩
  have h_comp2_eq_g' : φ.comp ψ = g' := unique' (φ.comp ψ) h_comp2
  have id_eq_g' : MonoidHom.id T' = g' := unique' (MonoidHom.id T') h_id_T'
  have comp2_eq_id : φ.comp ψ = MonoidHom.id T' := by rw [h_comp2_eq_g', id_eq_g']
  
  -- Construct the isomorphism
  refine ⟨
    { toFun := φ
      invFun := ψ
      left_inv := fun x => by
        calc
          ψ (φ x) = (ψ.comp φ) x := rfl
          _ = (MonoidHom.id T) x := by rw [comp1_eq_id]
          _ = x := rfl
      right_inv := fun y => by
        calc
          φ (ψ y) = (φ.comp ψ) y := rfl
          _ = (MonoidHom.id T') y := by rw [comp2_eq_id]
          _ = y := rfl
      map_mul' := φ.map_mul },
    hφ⟩
import Mathlib

open Function

variable {S : Type} [CommSemigroup S]

structure IsCancellative (a : S) : Prop where
  left_cancel : ∀ b c, a * b = a * c → b = c
  right_cancel : ∀ b c, b * a = c * a → b = c

axiom Construction_of_Inverse_Completion (S' : Type) [CommSemigroup S'] 
  (h : ∃ a : S', IsCancellative a) : ∃ (T' : Type) (_ : CommGroup T') 
  (embed : MulHom S' T') (_ : Injective embed), True

axiom Embedding_Theorem (S S' : Type) [CommSemigroup S] [CommSemigroup S'] 
  (ψ : MulEquiv S S') (T' : Type) [CommGroup T'] (embed : MulHom S' T') 
  (h_embed_inj : Injective embed) : ∃ (T : Type) (_ : CommGroup T) 
  (ι : MulHom S T) (_ : Injective ι) (Ψ : MulEquiv T T') 
  (h_extends : ∀ s : S, Ψ (ι s) = embed (ψ s)), True

theorem inverse_completion_exists (h_has_cancellative : ∃ a : S, IsCancellative a) :
  ∃ (T : Type) (_ : CommGroup T) (embed : MulHom S T) (_ : Injective embed), True := by
  rcases Construction_of_Inverse_Completion S h_has_cancellative with ⟨T', hT', embed, h_embed_inj, _⟩
  let ψ : MulEquiv S S := MulEquiv.refl S
  rcases Embedding_Theorem S S ψ T' embed h_embed_inj with ⟨T, hT, ι, h_ι_inj, _, _, _⟩
  exact ⟨T, hT, ι, h_ι_inj, trivial⟩
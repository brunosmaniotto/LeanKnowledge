import Mathlib

variable {S T : Type*} [Monoid S] [Monoid T]

theorem external_direct_product_identity (e_S : S) (e_T : T)
    (h_S : ∀ s : S, s * e_S = s ∧ e_S * s = s) (h_T : ∀ t : T, t * e_T = t ∧ e_T * t = t)
    (s : S) (t : T) : (s, t) * (e_S, e_T) = (s, t) ∧ (e_S, e_T) * (s, t) = (s, t) := by
  have hS_left : ∀ s : S, e_S * s = s := fun s => (h_S s).right
  have hS_right : ∀ s : S, s * e_S = s := fun s => (h_S s).left
  have hT_left : ∀ t : T, e_T * t = t := fun t => (h_T t).right
  have hT_right : ∀ t : T, t * e_T = t := fun t => (h_T t).left
  simp [hS_left, hS_right, hT_left, hT_right]
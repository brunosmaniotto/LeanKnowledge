import Mathlib

theorem semigroup_has_identity {S : Type} [Semigroup S] (s : S)
    (h : ∀ a : S, ∃ x y : S, s * x = a ∧ y * s = a) : ∃ e : S, ∀ a : S, e * a = a ∧ a * e = a := by
  -- From the condition for a = s, get v and w such that s * v = s and w * s = s.
  rcases h s with ⟨v, w, hv, hw⟩
  have left_id : ∀ a : S, w * a = a := by
    intro a
    rcases h a with ⟨x, _, hx, _⟩
    calc
      w * a = w * (s * x) := by rw [hx]
      _ = (w * s) * x := by rw [mul_assoc]
      _ = s * x := by rw [hw]
      _ = a := by rw [hx]

  have right_id : ∀ a : S, a * v = a := by
    intro a
    rcases h a with ⟨_, y, _, hy⟩
    calc
      a * v = (y * s) * v := by rw [hy]
      _ = y * (s * v) := by rw [mul_assoc]
      _ = y * s := by rw [hv]
      _ = a := by rw [hy]

  -- Show w = v
  have hwv : w * v = v := left_id v
  have hwv' : w * v = w := right_id w
  have h_eq : w = v := by
    calc
      w = w * v := by rw [hwv']
      _ = v := by rw [hwv]

  use w
  intro a
  constructor
  · exact left_id a
  · rw [h_eq]
    exact right_id a
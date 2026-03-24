import Mathlib

theorem inverse_of_permutation_is_permutation {α : Type*} [Nonempty α] (f : α → α) 
    (hf : Function.Bijective f) : Function.Bijective (Function.invFun f) := by
  rcases hf with ⟨hinj, hsurj⟩
  have left_inv : Function.LeftInverse (Function.invFun f) f := 
    Function.leftInverse_invFun hinj
  have right_inv : Function.RightInverse (Function.invFun f) f := 
    Function.rightInverse_invFun hsurj
  constructor
  · intro x y h
    have H : f (Function.invFun f x) = f (Function.invFun f y) := by rw [h]
    rw [right_inv x, right_inv y] at H
    exact H
  · intro x
    use f x
    exact left_inv x
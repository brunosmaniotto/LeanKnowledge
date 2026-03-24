import Mathlib

open BigOperators

theorem product_of_sums {A B E : Type*} [NormedCommRing E] [CompleteSpace E]
    (f : A → E) (g : B → E) (hA : Summable (fun a => ‖f a‖)) (hB : Summable (fun b => ‖g b‖)) :
    (∑' a, f a) * (∑' b, g b) = ∑' (p : A × B), f p.1 * g p.2 :=
  tsum_mul_tsum_of_summable_norm hA hB
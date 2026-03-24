import Mathlib

variable {R : Type} [Ring R]

def centralizerSubring (S : Set R) : Subring R :=
  { carrier := {x | ∀ s ∈ S, x * s = s * x}
    zero_mem' := by
      intro s hs
      simp
    one_mem' := by
      intro s hs
      simp
    add_mem' := by
      intro a b ha hb
      intro s hs
      have ha_s := ha s hs
      have hb_s := hb s hs
      calc
        (a + b) * s = a * s + b * s := by rw [add_mul]
        _ = s * a + s * b := by rw [ha_s, hb_s]
        _ = s * (a + b) := by rw [mul_add]
    neg_mem' := by
      intro a ha
      intro s hs
      have ha_s := ha s hs
      calc
        (-a) * s = -(a * s) := by rw [neg_mul]
        _ = -(s * a) := by rw [ha_s]
        _ = s * (-a) := by rw [mul_neg]
    mul_mem' := by
      intro a b ha hb
      intro s hs
      have ha_s := ha s hs
      have hb_s := hb s hs
      calc
        (a * b) * s = a * (b * s) := by rw [mul_assoc]
        _ = a * (s * b) := by rw [hb_s]
        _ = (a * s) * b := by rw [mul_assoc]
        _ = (s * a) * b := by rw [ha_s]
        _ = s * (a * b) := by rw [mul_assoc] }
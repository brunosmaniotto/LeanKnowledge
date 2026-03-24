import Mathlib
open BigOperators

noncomputable section

variable (S : ℕ) [NeZero S] (dims : Fin S → ℕ)

/-- Additive separable form: f(x) = G(∑ fⁱ(xⁱ)) with G strictly increasing -/
structure AddSepForm where
  G : ℝ → ℝ
  hG : StrictMono G
  sub : (i : Fin S) → (Fin (dims i) → ℝ) → ℝ

def AddSepForm.eval (af : AddSepForm S dims)
    (x : (i : Fin S) → Fin (dims i) → ℝ) : ℝ :=
  af.G (∑ i, af.sub i (x i))
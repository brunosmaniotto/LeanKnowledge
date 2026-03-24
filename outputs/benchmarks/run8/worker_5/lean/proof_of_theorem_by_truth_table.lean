import Mathlib.Tactic

open Classical

variable {α : Type}

inductive Form (α : Type) where
  | atom : α → Form α
  | neg : Form α → Form α
  | conj : Form α → Form α → Form α
  | disj : Form α → Form α → Form α
  | impl : Form α → Form α → Form α

namespace Form

def eval (v : α → Bool) : Form α → Bool
  | atom a => v a
  | neg φ => !eval v φ
  | conj φ ψ => eval v φ && eval v ψ
  | disj φ ψ => eval v φ || eval v ψ
  | impl φ ψ => !eval v φ || eval v ψ
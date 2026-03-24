import Mathlib

inductive Alt : Type
  | x | y | z
  deriving DecidableEq, Fintype

open Alt

def condorcetPref : Alt → Alt → Prop
  | x, y => True
  | y, z => True
  | z, x => True
  | _, _ => False

instance : DecidableRel condorcetPref := fun a b =>
  match a, b with
  | x, y => isTrue trivial
  | y, z => isTrue trivial
  | z, x => isTrue trivial
  | x, x => isFalse id
  | x, z => isFalse id
  | y, x => isFalse id
  | y, y => isFalse id
  | z, y => isFalse id
  | z, z => isFalse id
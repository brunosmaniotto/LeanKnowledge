import Mathlib

def condorcetPref : Fin 3 → Fin 3 → Fin 3 → Bool
  | 0, 0, 1 => true | 0, 0, 2 => true | 0, 1, 2 => true
  | 1, 1, 2 => true | 1, 1, 0 => true | 1, 2, 0 => true
  | 2, 2, 0 => true | 2, 2, 1 => true | 2, 0, 1 => true
  | _, _, _ => false
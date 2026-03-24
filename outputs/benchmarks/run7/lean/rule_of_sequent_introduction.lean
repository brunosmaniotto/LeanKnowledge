import Mathlib

theorem rule_of_sequent_intro_three {P1 P2 P3 Q : Prop} 
    (h1 : P1) (h2 : P2) (h3 : P3) (seq : P1 → P2 → P3 → Q) : Q :=
  seq h1 h2 h3
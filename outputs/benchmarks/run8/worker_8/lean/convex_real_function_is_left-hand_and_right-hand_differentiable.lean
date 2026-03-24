import Mathlib

theorem example_using_given_lemmas : ¬ ((Sum.inl () : Sum Unit Unit).isLeft ∧ (Sum.inl () : Sum Unit Unit).isRight) :=
  not_isLeft_and_isRight
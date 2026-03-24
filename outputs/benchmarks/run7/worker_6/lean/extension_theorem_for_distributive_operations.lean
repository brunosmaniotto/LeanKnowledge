import Mathlib

-- Sub-lemmas
lemma lambda_is_homomorphism {R T : Type*} [CommSemigroup R] [CommGroup T] (embed : R → T) 
  (embed_hom : ∀ x y, embed (x * y) = embed x * embed y) 
  (circ : R → R → R) 
  (h_dist : ∀ m x y, circ m (x * y) = circ m x * circ m y) 
  (m : R) : ∀ x y, embed (circ m (x * y)) = embed (circ m x) * embed (circ m y) := by
  intros x y
  rw [h_dist, embed_hom]
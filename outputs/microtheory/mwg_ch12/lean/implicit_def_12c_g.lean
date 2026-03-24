import Mathlib

/-!
# Spatial models of product differentiation

This file defines the basic components for spatial models of product differentiation,
where firms and consumers are located in a product space.
-/

/--
A spatial model of product differentiation.

- `P` is the type representing the product space. This type is expected to have an
  underlying notion of distance or similarity, although this structure does not
  explicitly require a `MetricSpace` instance.
- `firmLocations` is a set of points in `P`, where each point represents the 'address'
  of a firm in the product space.
- `consumerLocations` is a set of points in `P`, where each point represents an
  ideal consumption point ('address') for a consumer. The distribution of these
  points over the space `P` represents the consumer base.
-/
structure SpatialProductDifferentiationModel (P : Type*) where
  firmLocations : Set P
  consumerLocations : Set P
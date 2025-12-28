<div align="center">
    <h1>BBox Casting Algorithm</h1>
    <img src="https://github.com/LaVashikk/portal2-BBoxCast-v1/raw/main/other/logo.png" alt="Logo" width="350" height="350">
</div>
<br>
This document describes the implementation of an optimized BBox (Bounding Box) Casting algorithm for precise ray-entity collision detection. The algorithm uses analytical ray-AABB intersection methods combined with aggressive caching to achieve practical performance in production environments.

### Algorithm Overview

The BBox Casting algorithm employs a two-phase approach: a broad-phase search to collect candidate entities, followed by a narrow-phase analytical intersection test using the slab method. This architecture minimizes expensive operations while maintaining precision through mathematical ray-AABB intersection rather than point sampling.

The implementation is built around the `BboxTraceAnalyzer` class, which manages trace execution, entity filtering, and result caching through the `BufferedEntity` system.

### Algorithm Steps / Pipeline

1. Bounds guard
   - If start position fails a world-bounds check, return [start, null, null]. This avoids broken traces and scripting errors.

2. World trace budget
   - Run TraceLine(start, end) once to get the world hit point. The algorithm only searches entities up to this distance.

3. Segmentation
   - Split the ray into 4 equal segments (step = 0.25). For each segment, define a sub-ray centered on the segment and use its half-length as the search radius for candidate collection.

4. Candidate collection (dirty phase)
   - Enumerate entities within a sphere centered at the current segment center with radius equal to half the segment length.
   - Perform fast ignore checks:
     - Single-entity ignore (if ignoreEntities is a single instance).
     - Indexed ignore set (if ignoreEntities is an array/List).
     - Global ignore map (TracePlusIgnoreEnts), if present.
   - Resolve or rebuild a BufferedEntity from a global cache (EntBufferTable) keyed by entindex:
     - Cache includes entindex, classname, modelname, rounded origin (millimeter precision), and world-space AABB.
     - If the entity moved (origin rounded changed) or became invalid, the cache entry is rebuilt.
   - Run shouldHitEntityCached once per trace for the entity:
     - Apply settings.ApplyIgnoreFilter(ent): if true → skip.
     - Apply settings.ApplyCollisionFilter(ent): if true → keep.
     - Otherwise, check class/model lists from settings:
       - IgnoreClasses and IgnoredModels use substring matching; PriorityClasses overrides IgnoreClasses for matching classes.
     - Result is cached per-trace in BufferedEntity (no repeated calls within the same trace).
   - Handle “start inside”:
     - If the trace begins inside the entity’s AABB (first segment), the entity is flagged to be skipped to avoid immediate self-hits.
   - Broad-phase intersection:
     - A fast RayAabbIntersectFast over the current sub-ray gates the expensive narrow phase. A per-entity flag controls subsequent reuse to avoid repeated broad-phase work.

5. Narrow phase (analytic)
   - For candidates in the current segment, compute the exact hit using an unrolled slab intersection (RayAabbHitOptimized), which returns:
     - hit flag
     - entry t in [0, 1] along the sub-ray
     - exit t
     - axis-aligned face normal
   - Keep the closest entry (smallest t). If a hit is found in the segment, compute the hit point and return immediately.

6. Optional refinement
   - If settings.bynaryRefinement is enabled and the hit is not at the ends of the sub-ray, refine the point with a short binary search in a tight window around t. Iteration count is small by design to cap cost.

7. Fallback
   - If no entity was hit after all segments, return the world TraceLine hit position and null.

### Optimizations

**Caching Strategy:**
- Entity metadata (classname, modelname, entindex) cached once per entity
- AABB bounds cached with position-change detection via rounded integer comparison
- shouldHitEntity results cached per-trace via traceId tracking
- Ignore entities converted to hashmap for O(1) membership testing

**Computational Efficiency:**
- Analytical slab method replaces iterative point sampling
- Unrolled loop in RayAabbHitOptimized eliminates loop overhead
- Separate fast/optimized AABB functions avoid unnecessary normal calculation in broad phase
- Inline Vector comparison avoids function call overhead for cache validation
- Pre-computed direction vectors reused across slab calculations

**Early Termination:**
- Segment-based processing returns immediately on first hit
- Per-axis early exit in AABB intersection tests
- ignoreChecksCalc flag prevents repeated failed checks
- skipEntity flag handles rays starting inside entities

**Memory Management:**
- Entity buffer uses plain array instead of heavier collection types
- Buffer cleared after each segment to prevent unbounded growth
- Global EntBufferTable persists across traces for cross-trace caching

### Legacy Algorithm

A fallback implementation (outdated version) remains available for edge cases where the analytical approach may produce unexpected results. It can be enabled globally via `USE_LEGACY_BBOXCAST_ANALYZER = true`. The legacy algorithm uses point sampling along ray segments rather than analytical intersection, trading precision and performance for simpler logic. In practice, the analytical algorithm has proven stable and the legacy path is rarely needed.

### Conclusion

This BBox Casting implementation achieves precise ray-entity collision detection through analytical geometry while maintaining practical performance via aggressive caching and multi-phase filtering. The slab method provides exact intersection points and surface normals without iterative sampling, while the caching architecture eliminates redundant expensive operations. The segmented traversal with early termination ensures that computational cost scales with hit distance rather than total ray length, making the algorithm suitable for real-time game environments with dynamic entity populations.
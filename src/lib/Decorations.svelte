<script>
  import { onMount } from 'svelte';
  import Mark from './Mark.svelte';

  const COUNT = 30;
  const SIZE_MIN = 36;
  const SIZE_MAX = 56;
  const PADDING = 16;
  const EDGE_MARGIN = 8;
  const MAX_ATTEMPTS = 200;
  const RATE_MIN = 0.15;
  const RATE_MAX = 0.4;
  const MARK_SPEED = 0.5;
  const SIGMA_FRAC = 0.22;   // stddev as fraction of viewport dimension

  let marks = [];

  function randRange(min, max) {
    return min + Math.random() * (max - min);
  }

  function randNormal(mean, stddev) {
    // Box–Muller; guard against log(0)
    const u1 = Math.random() || 1e-9;
    const u2 = Math.random();
    return mean + stddev * Math.sqrt(-2 * Math.log(u1)) * Math.cos(2 * Math.PI * u2);
  }

  function shuffle(arr) {
    for (let i = arr.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [arr[i], arr[j]] = [arr[j], arr[i]];
    }
    return arr;
  }

  function generate() {
    const W = window.innerWidth;
    const H = window.innerHeight;
    const kinds = shuffle(
      Array.from({ length: COUNT }, (_, i) => (i % 2 === 0 ? 'x' : 'o'))
    );
    const placed = [];

    const sigmaX = W * SIGMA_FRAC;
    const sigmaY = H * SIGMA_FRAC;

    for (let i = 0; i < COUNT; i++) {
      const size = randRange(SIZE_MIN, SIZE_MAX);
      const half = size / 2 + EDGE_MARGIN;
      let cx = W / 2;
      let cy = H / 2;

      for (let attempt = 0; attempt < MAX_ATTEMPTS; attempt++) {
        cx = randNormal(W / 2, sigmaX);
        cy = randNormal(H / 2, sigmaY);
        if (cx < half || cx > W - half || cy < half || cy > H - half) continue;
        const collides = placed.some((m) => {
          const dx = cx - m.cx;
          const dy = cy - m.cy;
          return Math.hypot(dx, dy) < size / 2 + m.size / 2 + PADDING;
        });
        if (!collides) break;
      }

      placed.push({
        cx,
        cy,
        size,
        kind: kinds[i],
        rate: randRange(RATE_MIN, RATE_MAX),
        dir: Math.random() < 0.5 ? -1 : 1,
        x: (cx / W) * 100,
        y: (cy / H) * 100,
      });
    }

    marks = placed;
  }

  onMount(generate);
</script>

<div class="layer" style="--mark-speed: {MARK_SPEED};">
  {#each marks as m, i (i)}
    <Mark kind={m.kind} x={m.x} y={m.y} size={m.size} rate={m.rate} dir={m.dir} />
  {/each}
</div>

<style>
  .layer {
    position: fixed;
    inset: 0;
    z-index: 1;
    pointer-events: none;
    overflow: hidden;
    transform: translateY(calc(var(--scroll, 0) * var(--mark-speed, 0) * -1px));
    opacity: clamp(
      0,
      calc((var(--vh) - var(--scroll)) / (0.5 * var(--vh))),
      1
    );
    will-change: transform, opacity;
  }
</style>

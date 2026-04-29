<script>
  export let kind;   // 'x' | 'o'
  export let x;      // 0-100, percent of viewport width
  export let y;      // 0-100, percent of viewport height
  export let size;   // px
  export let rate;   // degrees per scrolled pixel, unsigned
  export let dir;    // 1 or -1
</script>

<div
  class="mark scroll-blur"
  style="--x-pct: {x}; --y-pct: {y}; --size: {size}px; --rate: {rate}; --dir: {dir};"
>
  {#if kind === 'x'}
    <svg viewBox="0 0 24 24" width={size} height={size} aria-hidden="true">
      <line x1="5" y1="5" x2="19" y2="19" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" />
      <line x1="19" y1="5" x2="5" y2="19" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" />
    </svg>
  {:else}
    <svg viewBox="0 0 24 24" width={size} height={size} aria-hidden="true">
      <circle cx="12" cy="12" r="8" stroke="currentColor" stroke-width="2.5" fill="none" />
    </svg>
  {/if}
</div>

<style>
  .mark {
    position: absolute;
    left: calc(var(--x-pct) * 1%);
    top: calc(var(--y-pct) * 1%);
    width: var(--size);
    height: var(--size);
    color: var(--text-muted);
    --speed: var(--mark-speed, 0.5);
    --initial-y: calc(var(--y-pct) * var(--vh) / 100);
    transform: translate(-50%, -50%)
      rotate(calc(var(--scroll, 0) * var(--rate) * var(--dir) * 1deg));
    will-change: transform;
  }

  svg {
    display: block;
  }
</style>

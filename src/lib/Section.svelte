<script>
  export let id = '';
  export let label = '';
  export let color = 'var(--surface)';
</script>

<section {id} class="section" style="background: {color};">
  <div class="label-strip">
    <span class="label-text">{label}</span>
  </div>
  <div class="content">
    <slot />
  </div>
</section>

<style>
  .section {
    display: flex;
    min-height: 320px; /* ← adjust minimum section height */
    border-bottom: 1px solid var(--border);
  }

  .label-strip {
    display: flex;
    align-items: flex-start;
    justify-content: center;
    width: 48px; /* ← adjust label bar width */
    flex-shrink: 0;
    padding: 1.5rem 0; /* ← adjust label bar padding */
    border-right: 1px solid var(--border);
  }

  .label-text {
    writing-mode: vertical-rl;
    text-orientation: mixed;
    transform: rotate(180deg);
    font-family: 'DM Mono', monospace;
    font-size: 0.65rem;
    font-weight: 500;
    letter-spacing: 0.12em;
    text-transform: uppercase;
    color: var(--text-muted);
    user-select: none;
  }

  .content {
    flex: 1;
    padding: 2.5rem 2.5rem; /* ← adjust section inner padding */
  }
</style>

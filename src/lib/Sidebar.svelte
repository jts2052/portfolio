<script>
  export let sections = [];

  function jumpTo(id) {
    document.getElementById(id)?.scrollIntoView({ behavior: 'smooth' });
  }
</script>

<aside class="sidebar">
  <div class="track" aria-hidden="true">
    <div class="fill"></div>
  </div>

  <nav class="nav" aria-label="Sections">
    {#each sections as s (s.id)}
      <button type="button" class="nav-link" on:click={() => jumpTo(s.id)}>
        {s.label}
      </button>
    {/each}
  </nav>
</aside>

<style>
  .sidebar {
    position: fixed;
    top: 0;
    right: 0;
    width: 110px;
    height: 100vh;
    z-index: 3;
    pointer-events: none;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .track {
    position: absolute;
    top: 24px;
    bottom: 24px;
    right: 14px;
    width: 2px;
    background: var(--border);
    border-radius: 1px;
    overflow: hidden;
  }

  .fill {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    background: var(--text-muted);
    height: calc(
      var(--scroll, 0) / max(1, var(--page-height, 1) - var(--vh, 1)) * 100%
    );
  }

  .nav {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 0.85rem;
    pointer-events: auto;
  }

  .nav-link {
    background: none;
    border: none;
    padding: 0.25rem 0.4rem;
    font-family: 'DM Mono', monospace;
    font-size: 0.7rem;
    font-weight: 500;
    letter-spacing: 0.12em;
    text-transform: uppercase;
    color: var(--text-muted);
    cursor: pointer;
    transition: color 0.15s;
  }

  .nav-link:hover,
  .nav-link:focus-visible {
    color: var(--text);
    outline: none;
  }
</style>

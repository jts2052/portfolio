<script>
  export let theme;
</script>

<header class="header">
  <span class="name">
    <span class="name-first">First</span>
    <span class="name-last">Last</span>
  </span>
  <div class="controls">
    <button class="theme-toggle" on:click={() => theme.update(t => t === 'dark' ? 'light' : 'dark')} aria-label="Toggle theme">
      {#if $theme === 'dark'}
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <circle cx="12" cy="12" r="5"/><line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/>
          <line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/>
          <line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/>
          <line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/>
        </svg>
      {:else}
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/>
        </svg>
      {/if}
    </button>
    <div class="avatar" aria-label="Avatar">
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
        <circle cx="12" cy="7" r="4"/>
      </svg>
    </div>
  </div>
</header>

<style>
  .header {
    position: sticky;
    top: 0;
    z-index: 100;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 2rem;
    height: 56px;
    background: var(--bg);
    border-bottom: 1px solid var(--border);
  }

  .name {
    font-family: 'Syne', sans-serif;
    font-weight: 800;
    font-size: 1.35rem;
    letter-spacing: -0.02em;
    color: var(--accent);
  }

  .name-first { margin-right: 0.4em; }

  .controls {
    display: flex;
    align-items: center;
    gap: 0.75rem;
  }

  .theme-toggle {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 32px;
    height: 32px;
    background: none;
    border: 1px solid var(--border);
    border-radius: 6px;
    color: var(--text-muted);
    cursor: pointer;
    transition: color 0.15s, border-color 0.15s;
  }

  .theme-toggle:hover {
    color: var(--text);
    border-color: var(--text-muted);
  }

  .avatar {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 36px;
    height: 36px;
    border-radius: 50%;
    border: 1px solid var(--border);
    color: var(--text-muted);
    background: var(--surface);
  }
</style>

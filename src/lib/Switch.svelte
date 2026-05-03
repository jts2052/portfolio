<script>
  import { onMount, onDestroy } from 'svelte';

  const POLL_MS = 5000;

  let count = 0;
  let loaded = false;
  let pollHandle;

  $: isOn = count % 2 === 1;
  $: formatted = count.toLocaleString();

  async function fetchCount() {
    try {
      const res = await fetch('/api/clicks');
      if (!res.ok) return;
      const data = await res.json();
      count = data.count;
      loaded = true;
    } catch {
      /* network blip — leave existing count */
    }
  }

  async function flip() {
    const previous = count;
    count = previous + 1;
    try {
      const res = await fetch('/api/clicks', { method: 'POST' });
      if (!res.ok) {
        count = previous;
        return;
      }
      const data = await res.json();
      count = data.count;
    } catch {
      count = previous;
    }
  }

  onMount(() => {
    fetchCount();
    pollHandle = setInterval(fetchCount, POLL_MS);
  });

  onDestroy(() => {
    if (pollHandle) clearInterval(pollHandle);
  });
</script>

<div class="switch-block">
  <button
    type="button"
    class="switch"
    class:on={isOn}
    aria-pressed={isOn}
    aria-label="Flip the global switch"
    on:click={flip}
  >
    <span class="dot"></span>
  </button>
  <p class="caption">
    {#if loaded}
      switch has been flipped {formatted} times worldwide
    {:else}
      &nbsp;
    {/if}
  </p>
</div>

<style>
  .switch-block {
    position: fixed;
    top: calc(5vw - var(--t) * (5vw - 2vh));
    right: calc(2vw - var(--t) * (2vw - 2vh));
    z-index: 10;
    display: flex;
    flex-direction: column;
    align-items: flex-end;
    gap: calc(1rem - var(--t) * (1rem - 0.25rem));
    padding: calc(var(--t) * 0.5rem) calc(var(--t) * 0.85rem);
    border-radius: 10px;
    background: rgba(14, 14, 14, calc(var(--t) * 0.45));
    backdrop-filter: blur(calc(var(--t) * 10px));
    -webkit-backdrop-filter: blur(calc(var(--t) * 10px));
  }

  .switch {
    --switch-w: calc(7rem - var(--t) * (7rem - 2.25rem));
    --switch-h: calc(var(--switch-w) * 0.55);
    --pad: calc(var(--switch-h) * 0.1);

    width: var(--switch-w);
    height: var(--switch-h);
    padding: var(--pad);
    border: 2px solid var(--text-muted);
    border-radius: 9999px;
    background: transparent;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: flex-start;
    transition: border-color 0.2s, background-color 0.2s;
  }

  .switch.on {
    border-color: var(--text);
    background: var(--text);
  }

  .switch:focus-visible {
    outline: 2px solid var(--accent);
    outline-offset: 3px;
  }

  .dot {
    display: block;
    width: calc(var(--switch-h) - 2 * var(--pad) - 4px);
    height: calc(var(--switch-h) - 2 * var(--pad) - 4px);
    border-radius: 50%;
    background: var(--text-muted);
    transform: translateX(0);
    transition: transform 0.25s cubic-bezier(0.4, 0, 0.2, 1), background-color 0.25s;
  }

  .switch.on .dot {
    transform: translateX(calc(var(--switch-w) - var(--switch-h)));
    background: var(--bg);
  }

  .caption {
    font-family: 'Outfit', sans-serif;
    font-weight: 400;
    font-size: calc(1rem - var(--t) * (1rem - 0.7rem));
    color: var(--text-muted);
    letter-spacing: 0.12em;
    text-transform: uppercase;
    text-align: right;
    margin: 0;
    white-space: nowrap;
  }
</style>

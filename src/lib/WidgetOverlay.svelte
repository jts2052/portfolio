<script>
  import { onMount } from 'svelte';
  import { fade } from 'svelte/transition';
  import WidgetRow from './WidgetRow.svelte';

  export let rows = [];
  export let assetBase;
  export let onClose;

  function handleKey(e) {
    if (e.key === 'Escape') onClose();
  }

  function handleBackdrop(e) {
    if (e.target === e.currentTarget) onClose();
  }

  onMount(() => {
    const prevOverflow = document.documentElement.style.overflow;
    document.documentElement.style.overflow = 'hidden';
    window.addEventListener('keydown', handleKey);
    return () => {
      document.documentElement.style.overflow = prevOverflow;
      window.removeEventListener('keydown', handleKey);
    };
  });
</script>

<div
  class="backdrop"
  on:click={handleBackdrop}
  role="presentation"
  transition:fade={{ duration: 150 }}
>
  <div class="overlay" role="dialog" aria-modal="true">
    <button
      type="button"
      class="close"
      on:click={onClose}
      aria-label="Close"
    >×</button>
    <div class="rows">
      {#each rows as row}
        <WidgetRow {row} {assetBase} />
      {/each}
    </div>
  </div>
</div>

<style>
  .backdrop {
    position: fixed;
    inset: 0;
    z-index: 100;
    background: rgba(0, 0, 0, 0.7);
    backdrop-filter: blur(4px);
    -webkit-backdrop-filter: blur(4px);
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 4rem 2rem;
  }

  .overlay {
    position: relative;
    width: 100%;
    max-width: 1000px;
    max-height: 100%;
    overflow-y: auto;
    padding: 3rem 3rem 3rem;
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 12px;
    scrollbar-width: thin;
  }

  .rows {
    display: flex;
    flex-direction: column;
    gap: 1.5rem;
  }

  .close {
    position: absolute;
    top: 1rem;
    right: 1rem;
    width: 2.25rem;
    height: 2.25rem;
    border: none;
    border-radius: 50%;
    background: transparent;
    color: var(--text-muted);
    font-size: 1.5rem;
    line-height: 1;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: background-color 0.15s, color 0.15s;
  }

  .close:hover {
    background: var(--border);
    color: var(--text);
  }

  .close:focus-visible {
    outline: 2px solid var(--accent);
    outline-offset: 2px;
  }
</style>

<script>
  import { createEventDispatcher, onMount, onDestroy } from 'svelte';

  export let title = '';

  const dispatch = createEventDispatcher();

  function close() {
    dispatch('close');
  }

  function handleKeydown(e) {
    if (e.key === 'Escape') close();
  }

  onMount(() => {
    document.addEventListener('keydown', handleKeydown);
    document.body.style.overflow = 'hidden';
  });

  onDestroy(() => {
    document.removeEventListener('keydown', handleKeydown);
    document.body.style.overflow = '';
  });
</script>

<div class="backdrop" on:click={close} role="presentation">
  <div class="modal" on:click|stopPropagation role="dialog" aria-modal="true" aria-label={title}>
    <div class="modal-header">
      <h2 class="modal-title">{title}</h2>
      <button class="close-btn" on:click={close} aria-label="Close">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
        </svg>
      </button>
    </div>
    <div class="modal-body">
      <slot />
    </div>
  </div>
</div>

<style>
  .backdrop {
    position: fixed;
    inset: 0;
    background: rgba(0, 0, 0, 0.6);
    backdrop-filter: blur(4px);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 200;
  }

  .modal {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 10px; /* ← adjust corner radius */
    width: min(720px, 94vw); /* ← modal width */
    max-height: 80vh; /* ← modal max height */
    display: flex;
    flex-direction: column;
    overflow: hidden;
  }

  .modal-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 1.25rem 1.5rem;
    border-bottom: 1px solid var(--border);
    flex-shrink: 0;
  }

  .modal-title {  
    font-family: 'Syne', sans-serif;
    font-weight: 800;
    font-size: 1.1rem;
    color: var(--text);
    margin: 0;
  }

  .close-btn {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 28px;
    height: 28px;
    background: none;
    border: 1px solid var(--border);
    border-radius: 6px;
    color: var(--text-muted);
    cursor: pointer;
    transition: color 0.15s, border-color 0.15s;
  }

  .close-btn:hover {
    color: var(--text);
    border-color: var(--text-muted);
  }

  .modal-body {
    padding: 1.5rem;
    overflow-y: auto;
  }
</style>

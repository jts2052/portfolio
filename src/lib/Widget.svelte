<script>
  import WidgetOverlay from './WidgetOverlay.svelte';

  export let slug;

  const widgetData = import.meta.glob('../widgets/*.json', { eager: true, import: 'default' });

  $: data = widgetData[`../widgets/${slug}.json`];
  $: assetBase = `/widgets/${slug}`;

  let open = false;
</script>

<button class="widget" type="button" on:click={() => (open = true)}>
  {#if data?.preview?.thumbnail}
    <img class="thumb" src="{assetBase}/{data.preview.thumbnail}" alt="" />
  {/if}
  <div class="preview-text">
    {#if data?.preview?.header}
      <span class="header">{data.preview.header}</span>
    {/if}
    {#if data?.preview?.title}
      <span class="title">{data.preview.title}</span>
    {/if}
  </div>
</button>

{#if open && data}
  <WidgetOverlay rows={data.rows ?? []} {assetBase} onClose={() => (open = false)} />
{/if}

<style>
  .widget {
    appearance: none;
    background: var(--bg);
    border: 1px solid var(--border);
    border-radius: 8px;
    padding: 0;
    color: inherit;
    font: inherit;
    text-align: left;
    cursor: pointer;

    display: flex;
    flex-direction: column;
    overflow: hidden;
    transition: border-color 0.15s;
  }

  .widget:hover {
    border-color: var(--text-muted);
  }

  .widget:focus-visible {
    outline: 2px solid var(--accent);
    outline-offset: 2px;
  }

  .thumb {
    width: 100%;
    aspect-ratio: 16 / 9;
    object-fit: cover;
    display: block;
    background: var(--surface);
  }

  .preview-text {
    padding: 1rem 1.25rem 1.25rem;
    display: flex;
    flex-direction: column;
    gap: 0.4rem;
    flex: 1;
  }

  .header {
    font-family: 'Outfit', sans-serif;
    font-weight: 800;
    font-size: 1.15rem;
    color: var(--text);
    letter-spacing: -0.01em;
    line-height: 1.2;
  }

  .title {
    font-family: 'Outfit', sans-serif;
    font-weight: 400;
    font-size: 0.75rem;
    color: var(--text-muted);
    letter-spacing: 0.12em;
    text-transform: uppercase;
  }
</style>

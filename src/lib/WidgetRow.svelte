<script>
  export let row;
  export let assetBase;
</script>

{#if row.header}
  <h2 class="header">{row.header}</h2>
{:else if row.title}
  <h3 class="title">{row.title}</h3>
{:else if row.text}
  <p class="text">{row.text}</p>
{:else if row.images}
  <div class="media">
    {#each row.images as src}
      <img src="{assetBase}/{src}" alt="" />
    {/each}
  </div>
{:else if row.videos}
  <div class="media">
    {#each row.videos as src}
      <video src="{assetBase}/{src}" controls preload="metadata"></video>
    {/each}
  </div>
{/if}

<style>
  .header {
    font-family: 'Outfit', sans-serif;
    font-weight: 800;
    font-size: 2rem;
    color: var(--text);
    letter-spacing: -0.01em;
  }

  .title {
    font-family: 'Outfit', sans-serif;
    font-weight: 500;
    font-size: 0.85rem;
    color: var(--text-muted);
    letter-spacing: 0.12em;
    text-transform: uppercase;
  }

  .text {
    font-family: 'Outfit', sans-serif;
    font-weight: 300;
    font-size: 1rem;
    line-height: 1.6;
    color: var(--text);
  }

  .media {
    display: flex;
    flex-direction: row;
    gap: 1rem;
    width: 100%;
  }

  .media img,
  .media video {
    flex: 1;
    width: 0;
    min-width: 0;
    height: auto;
    border-radius: 6px;
    background: var(--bg);
    object-fit: cover;
    display: block;
  }
</style>

<script>
  export let title = '';
  export let description = '';
  export let tags = [];
  export let repoUrl = '';
  export let liveUrl = '';
</script>

<div class="card">
  <div class="card-body">
    <h3 class="card-title">{title}</h3>
    <p class="card-desc">{description}</p>
    <div class="tags">
      {#each tags as tag}
        <span class="tag">{tag}</span>
      {/each}
    </div>
  </div>
  <div class="card-footer">
    {#if repoUrl}
      <a href={repoUrl} target="_blank" rel="noopener noreferrer" class="link">Repo</a>
    {/if}
    {#if liveUrl}
      <a href={liveUrl} target="_blank" rel="noopener noreferrer" class="link link-live">Live</a>
    {/if}
  </div>
</div>

<style>
  .card {
    display: flex;
    flex-direction: column;
    background: var(--bg);
    border: 1px solid var(--border);
    border-radius: 8px;
    overflow: hidden;
    transition: border-color 0.15s;
  }

  .card:hover {
    border-color: var(--text-muted);
  }

  .card-body {
    flex: 1;
    padding: 1.25rem;
    display: flex;
    flex-direction: column;
    gap: 0.6rem;
  }

  .card-title {
    font-family: 'Syne', sans-serif;
    font-weight: 800;
    font-size: 0.95rem;
    color: var(--text);
    margin: 0;
  }

  .card-desc {
    font-family: 'DM Mono', monospace;
    font-size: 0.78rem;
    font-weight: 300;
    color: var(--text-muted);
    line-height: 1.6;
    margin: 0;
    flex: 1;
  }

  .tags {
    display: flex;
    flex-wrap: wrap;
    gap: 0.35rem;
    margin-top: 0.25rem;
  }

  .tag {
    font-family: 'DM Mono', monospace;
    font-size: 0.65rem;
    font-weight: 500;
    letter-spacing: 0.05em;
    color: var(--text-muted);
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 4px;
    padding: 0.15rem 0.5rem;
  }

  .card-footer {
    display: flex;
    gap: 0.5rem;
    padding: 0.75rem 1.25rem;
    border-top: 1px solid var(--border);
  }

  .link {
    font-family: 'DM Mono', monospace;
    font-size: 0.7rem;
    font-weight: 500;
    letter-spacing: 0.05em;
    text-decoration: none;
    color: var(--text-muted);
    border: 1px solid var(--border);
    border-radius: 4px;
    padding: 0.25rem 0.65rem;
    transition: color 0.15s, border-color 0.15s;
  }

  .link:hover {
    color: var(--text);
    border-color: var(--text-muted);
  }

  .link-live {
    color: var(--accent);
    border-color: var(--accent);
    opacity: 0.7;
  }

  .link-live:hover {
    opacity: 1;
  }
</style>

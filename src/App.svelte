<svelte:head>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous">
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;800&display=swap" rel="stylesheet">
</svelte:head>

<script>
  import { onMount } from 'svelte';
  import Sidebar from './lib/Sidebar.svelte';
  import RobotViewer from './lib/RobotViewer.svelte';
  import Switch from './lib/Switch.svelte';
  import Widget from './lib/Widget.svelte';

  const sections = [
    { id: 'top', label: 'Top' },
    { id: 'about', label: 'About', widgets: ['about'] },
    { id: 'experience', label: 'Experience', widgets: ['thg', 'thg-intern'] },
    { id: 'projects', label: 'Projects', widgets: [] },
    { id: 'contact', label: 'Contact', widgets: [] },
  ];

  function updateScroll() {
    document.documentElement.style.setProperty('--scroll', window.scrollY);
  }

  function updateSize() {
    const root = document.documentElement;
    root.style.setProperty('--vh', window.innerHeight);
    root.style.setProperty('--page-height', root.scrollHeight);
  }

  onMount(() => {
    updateSize();
    updateScroll();
    window.addEventListener('scroll', updateScroll, { passive: true });
    window.addEventListener('resize', updateSize);
    return () => {
      window.removeEventListener('scroll', updateScroll);
      window.removeEventListener('resize', updateSize);
    };
  });
</script>

<div class="app">
  <header class="hero-text">
    <h1 class="name">Jacob Smith</h1>
    <p class="title">Software Engineer</p>
  </header>

  <Switch />

  <section class="hero" id="top"></section>

  <!-- <RobotViewer /> -->

  {#each sections.slice(1) as s (s.id)}
    <section class="panel" id={s.id}>
      <span class="panel-label">{s.label}</span>
      {#if s.widgets?.length}
        <div class="widgets-box">
          {#each s.widgets as slug (slug)}
            <Widget {slug} />
          {/each}
        </div>
      {/if}
    </section>
  {/each}

  <Sidebar {sections} />
</div>

<style>
  :global(*, *::before, *::after) {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
  }

  :global(html, body) {
    margin: 0;
    padding: 0;
  }

  :global(html) {
    scrollbar-width: none;
  }

  :global(html::-webkit-scrollbar) {
    display: none;
  }

  :global(:root) {
    --bg: #0e0e0e;
    --surface: #161616;
    --border: #242424;
    --text: #d0d0d0;
    --text-muted: #555555;
    --accent: #8faab3;

    --scroll: 0;
    --vh: 800;
    --page-height: 1600;

    --sidebar-width: 110px;

    --t: clamp(0, calc(var(--scroll) / var(--vh)), 1);
  }

  .app {
    background: var(--bg);
    color: var(--text);
    font-family: 'Outfit', sans-serif;
  }

  .hero {
    height: 100vh;
  }

  .hero-text {
    position: fixed;
    top: calc(5vw - var(--t) * (5vw - 2vh));
    left: calc(3vw + var(--t) * (3vw - 3vw));
    z-index: 10;
    text-align: left;
    padding: calc(var(--t) * 0.2rem) calc(var(--t) * 0.75rem);
    border-radius: 10px;
    background: rgba(14, 14, 14, calc(var(--t) * 0.45));
    backdrop-filter: blur(calc(var(--t) * 10px));
    -webkit-backdrop-filter: blur(calc(var(--t) * 10px));
  }

  .name {
    font-family: 'Outfit', sans-serif;
    font-weight: 800;
    font-size: calc(4rem - var(--t) * (4rem - 1.25rem));
    color: var(--text);
    letter-spacing: -0.02em;
    line-height: 1;
  }

  .title {
    font-family: 'Outfit', sans-serif;
    font-weight: 400;
    font-size: calc(0.8rem - var(--t) * (0.8rem - 0.7rem));
    color: var(--text-muted);
    letter-spacing: 0.12em;
    text-transform: uppercase;
    margin-top: calc(0.5rem - var(--t) * (0.5rem - 0.25rem));
  }

  .panel {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    padding: 2rem var(--sidebar-width) 2rem 2rem;
    gap: 1rem;
  }

  .panel-label {
    font-family: 'Outfit', sans-serif;
    font-weight: 800;
    font-size: clamp(2rem, 5vw, 3rem);
    color: var(--text-muted);
    letter-spacing: -0.01em;
  }

  .widgets-box {
    flex: 1;
    height: 100%;
    width: 100%;
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    align-content: start;
    gap: 1.5rem;
    padding: 1.5rem;
    background: var(--surface);
    border-radius: 12px;
  }
</style>

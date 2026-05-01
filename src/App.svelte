<svelte:head>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous">
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@800&family=DM+Mono:wght@300;400;500&display=swap" rel="stylesheet">
</svelte:head>

<script>
  import { onMount } from 'svelte';
  import Sidebar from './lib/Sidebar.svelte';

  const sections = [
    { id: 'top', label: 'Top' },
    { id: 'about', label: 'About' },
    { id: 'projects', label: 'Projects' },
    { id: 'experience', label: 'Experience' },
    { id: 'contact', label: 'Contact' },
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

  <section class="hero" id="top"></section>

  {#each sections.slice(1) as s (s.id)}
    <section class="panel" id={s.id}>
      <div class="panel-content">
        <span class="panel-label">{s.label}</span>
      </div>
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

    --t: clamp(0, calc(var(--scroll) / var(--vh)), 1);
  }

  .app {
    background: var(--bg);
    color: var(--text);
    font-family: 'DM Mono', monospace;
  }

  .hero {
    height: 100vh;
  }

  .hero-text {
    position: fixed;
    top: calc(10vw - var(--t) * (10vw - 2vh));
    left: calc(2vw + var(--t) * (2vh - 2vw));
    z-index: 10;
    text-align: left;
    padding: calc(var(--t) * 0.5rem) calc(var(--t) * 0.85rem);
    border-radius: 10px;
    background: rgba(14, 14, 14, calc(var(--t) * 0.45));
    backdrop-filter: blur(calc(var(--t) * 10px));
    -webkit-backdrop-filter: blur(calc(var(--t) * 10px));
  }

  .name {
    font-family: 'Outfit', sans-serif;
    font-weight: 800;
    font-size: calc(5rem - var(--t) * (5rem - 1.25rem));
    color: var(--text);
    letter-spacing: -0.02em;
    line-height: 1;
  }

  .title {
    font-family: 'DM Mono', monospace;
    font-weight: 400;
    font-size: calc(1rem - var(--t) * (1rem - 0.7rem));
    color: var(--text-muted);
    letter-spacing: 0.12em;
    text-transform: uppercase;
    margin-top: calc(1rem - var(--t) * (1rem - 0.25rem));
  }

  .panel {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0 2rem;
  }

  .panel-content {
    text-align: center;
  }

  .panel-label {
    font-family: 'Syne', sans-serif;
    font-weight: 800;
    font-size: clamp(2rem, 5vw, 3rem);
    color: var(--text-muted);
    letter-spacing: -0.01em;
  }
</style>

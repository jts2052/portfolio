<svelte:head>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous">
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@800&family=DM+Mono:wght@300;400;500&display=swap" rel="stylesheet">
</svelte:head>

<script>
  import { onMount } from 'svelte';
  import Decorations from './lib/Decorations.svelte';
  import Sidebar from './lib/Sidebar.svelte';

  const sections = [
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
  <section class="hero">
    <div class="hero-text scroll-blur">
      <h1 class="name">Jacob Smith</h1>
      <p class="title">Software Engineer</p>
    </div>
  </section>

  {#each sections as s (s.id)}
    <section class="panel" id={s.id}>
      <div class="panel-content">
        <span class="panel-label">{s.label}</span>
      </div>
    </section>
  {/each}

  <Decorations />
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

    --blur-threshold-vh: 0.35;
    --blur-rate: 0.06;
    --blur-max: 14px;
  }

  :global(.scroll-blur) {
    filter: blur(clamp(
      0px,
      calc(
        (var(--blur-threshold-vh) * var(--vh)
          - var(--initial-y)
          + var(--scroll) * var(--speed))
        * var(--blur-rate) * 1px
      ),
      var(--blur-max)
    ));
  }

  .app {
    background: var(--bg);
    color: var(--text);
    font-family: 'DM Mono', monospace;
  }

  .hero {
    height: 100vh;
    display: flex;
    align-items: center;
    justify-content: flex-start;
    padding-left: 25vw;
  }

  .hero-text {
    text-align: left;
    position: relative;
    z-index: 2;
    --speed: 1;
    --initial-y: calc(0.5 * var(--vh));
  }

  .name {
    font-family: 'Syne', sans-serif;
    font-weight: 800;
    font-size: clamp(2.5rem, 8vw, 5rem);
    color: var(--text);
    letter-spacing: -0.02em;
    line-height: 1;
  }

  .title {
    font-family: 'DM Mono', monospace;
    font-weight: 400;
    font-size: clamp(0.85rem, 1.6vw, 1rem);
    color: var(--text-muted);
    letter-spacing: 0.12em;
    text-transform: uppercase;
    margin-top: 1rem;
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

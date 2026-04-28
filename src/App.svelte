<svelte:head>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous">
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@800&family=DM+Mono:wght@300;400;500&display=swap" rel="stylesheet">
</svelte:head>

<script>
  import { writable } from 'svelte/store';
  import Header from './lib/Header.svelte';
  import Section from './lib/Section.svelte';
  import Modal from './lib/Modal.svelte';
  import ProjectCard from './lib/ProjectCard.svelte';

  export const theme = writable('dark');

  let modalOpen = false;
  let modalTitle = '';
  let modalContent = '';

  function openModal(title, content) {
    modalTitle = title;
    modalContent = content;
    modalOpen = true;
  }

  function closeModal() {
    modalOpen = false;
  }

  const projects = [
    {
      title: 'TaskFlow',
      description: 'A terminal-first project management tool with Kanban boards, time tracking, and Git integration.',
      tags: ['Go', 'CLI', 'SQLite'],
      repoUrl: '#',
      liveUrl: '',
    },
    {
      title: 'DataSync',
      description: 'Real-time database synchronization library supporting conflict resolution and offline-first operation.',
      tags: ['TypeScript', 'WebSockets', 'PostgreSQL'],
      repoUrl: '#',
      liveUrl: '#',
    },
    {
      title: 'AuthKit',
      description: 'Composable authentication middleware for Node.js — JWT, OAuth2, and session-based auth in one package.',
      tags: ['Node.js', 'TypeScript', 'OAuth2'],
      repoUrl: '#',
      liveUrl: '',
    },
    {
      title: 'LogPilot',
      description: 'Structured logging service with a web UI for filtering, search, and alerting on log patterns.',
      tags: ['Python', 'FastAPI', 'React'],
      repoUrl: '#',
      liveUrl: '#',
    },
    {
      title: 'GridQL',
      description: 'Visual GraphQL query builder that generates typed client code and documents your schema automatically.',
      tags: ['GraphQL', 'TypeScript', 'Vite'],
      repoUrl: '#',
      liveUrl: '#',
    },
    {
      title: 'NightWatch',
      description: 'Lightweight uptime monitor with status pages, incident history, and multi-channel alerting.',
      tags: ['Go', 'HTMX', 'SQLite'],
      repoUrl: '#',
      liveUrl: '',
    },
  ];
</script>

<div class="app" data-theme={$theme}>
  <Header {theme} />

  <main>
    <Section id="about" label="About" color="var(--section-a)">
      <div class="about-content">
        <p class="about-lead">
          Software engineer focused on building tools that make other engineers faster.
          I work across the stack with a preference for systems-level thinking and clean interfaces.
        </p>
        <p class="about-body">
          Currently working on distributed systems and developer tooling. Previously built
          data infrastructure and internal platforms at a few early-stage startups.
          I care about correctness, observability, and writing code that's easy to delete.
        </p>
        <div class="about-meta">
          <span class="meta-item">Based in [City]</span>
          <span class="meta-sep">·</span>
          <span class="meta-item">Open to opportunities</span>
        </div>
      </div>
    </Section>

    <Section id="projects" label="Projects" color="var(--section-b)">
      <div class="section-header">
        <h2 class="section-title">Selected Projects</h2>
      </div>
      <div class="project-grid">
        {#each projects as project}
          <ProjectCard {...project} />
        {/each}
      </div>
    </Section>

    <Section id="experience" label="Experience" color="var(--section-c)">
      <div class="section-header">
        <h2 class="section-title">Experience</h2>
      </div>
      <div class="timeline">
        <div class="timeline-item">
          <div class="timeline-meta">
            <span class="timeline-date">2023 – Present</span>
          </div>
          <div class="timeline-body">
            <h3 class="timeline-role">Senior Software Engineer</h3>
            <span class="timeline-company">Company Name</span>
            <p class="timeline-desc">
              Building and maintaining distributed systems for data ingestion and processing.
              Led migration of core pipeline from monolith to services, reducing p99 latency by 40%.
            </p>
          </div>
        </div>
        <div class="timeline-item">
          <div class="timeline-meta">
            <span class="timeline-date">2021 – 2023</span>
          </div>
          <div class="timeline-body">
            <h3 class="timeline-role">Software Engineer</h3>
            <span class="timeline-company">Previous Company</span>
            <p class="timeline-desc">
              Full-stack development on internal tooling and customer-facing APIs.
              Owned the authentication layer and developer onboarding experience.
            </p>
          </div>
        </div>
        <div class="timeline-item">
          <div class="timeline-meta">
            <span class="timeline-date">2019 – 2021</span>
          </div>
          <div class="timeline-body">
            <h3 class="timeline-role">Software Engineer</h3>
            <span class="timeline-company">First Company</span>
            <p class="timeline-desc">
              Backend engineering on a B2B SaaS platform.
              Built data export pipelines and REST APIs consumed by third-party integrations.
            </p>
          </div>
        </div>
      </div>
    </Section>

    <Section id="contact" label="Contact" color="var(--section-d)">
      <div class="contact-content">
        <p class="contact-lead">
          Reach out via email or find me on the platforms below.
        </p>
        <div class="contact-links">
          <a href="mailto:you@example.com" class="contact-link">
            <span class="contact-link-label">Email</span>
            <span class="contact-link-value">you@example.com</span>
          </a>
          <a href="https://github.com" target="_blank" rel="noopener noreferrer" class="contact-link">
            <span class="contact-link-label">GitHub</span>
            <span class="contact-link-value">github.com/username</span>
          </a>
          <a href="https://linkedin.com" target="_blank" rel="noopener noreferrer" class="contact-link">
            <span class="contact-link-label">LinkedIn</span>
            <span class="contact-link-value">linkedin.com/in/username</span>
          </a>
        </div>
      </div>
    </Section>
  </main>

  {#if modalOpen}
    <Modal title={modalTitle} on:close={closeModal}>
      <p>{modalContent}</p>
    </Modal>
  {/if}
</div>

<style>
  :global(*, *::before, *::after) {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
  }

  :global(body) {
    margin: 0;
    padding: 0;
  }

  :global([data-theme='dark']) {
    --bg: #0e0e0e;
    --surface: #161616;
    --border: #242424;
    --text: #d0d0d0;
    --text-muted: #555555;
    --accent: #8faab3;
    --section-a: #101214;
    --section-b: #101210;
    --section-c: #131010;
    --section-d: #111110;
  }

  :global([data-theme='light']) {
    --bg: #f5f5f3;
    --surface: #ffffff;
    --border: #e0e0dc;
    --text: #1a1a1a;
    --text-muted: #888880;
    --accent: #4a7a8a;
    --section-a: #eff3f5;
    --section-b: #eff3ef;
    --section-c: #f5efef;
    --section-d: #f3f2ef;
  }

  .app {
    min-height: 100vh;
    background: var(--bg);
    color: var(--text);
    font-family: 'DM Mono', monospace;
    transition: background 0.2s, color 0.2s;
  }

  /* About */
  .about-content {
    max-width: 640px;
    display: flex;
    flex-direction: column;
    gap: 1rem;
  }

  .about-lead {
    font-size: 1rem;
    font-weight: 400;
    line-height: 1.7;
    color: var(--text);
  }

  .about-body {
    font-size: 0.85rem;
    font-weight: 300;
    line-height: 1.8;
    color: var(--text-muted);
  }

  .about-meta {
    display: flex;
    gap: 0.5rem;
    align-items: center;
    margin-top: 0.5rem;
  }

  .meta-item {
    font-size: 0.72rem;
    font-weight: 500;
    letter-spacing: 0.05em;
    color: var(--text-muted);
  }

  .meta-sep {
    color: var(--border);
  }

  /* Section shared */
  .section-header {
    margin-bottom: 1.5rem;
  }

  .section-title {
    font-family: 'Syne', sans-serif;
    font-weight: 800;
    font-size: 1rem;
    color: var(--text-muted);
    letter-spacing: 0.04em;
    text-transform: uppercase;
  }

  /* Projects */
  .project-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 1rem;
  }

  @media (max-width: 900px) {
    .project-grid {
      grid-template-columns: repeat(2, 1fr);
    }
  }

  @media (max-width: 560px) {
    .project-grid {
      grid-template-columns: 1fr;
    }
  }

  /* Experience */
  .timeline {
    display: flex;
    flex-direction: column;
    gap: 0;
  }

  .timeline-item {
    display: flex;
    gap: 2rem;
    padding: 1.5rem 0;
    border-bottom: 1px solid var(--border);
  }

  .timeline-item:last-child {
    border-bottom: none;
  }

  .timeline-meta {
    width: 100px;
    flex-shrink: 0;
  }

  .timeline-date {
    font-size: 0.72rem;
    font-weight: 500;
    letter-spacing: 0.05em;
    color: var(--text-muted);
  }

  .timeline-body {
    display: flex;
    flex-direction: column;
    gap: 0.4rem;
  }

  .timeline-role {
    font-family: 'Syne', sans-serif;
    font-weight: 800;
    font-size: 0.9rem;
    color: var(--text);
  }

  .timeline-company {
    font-size: 0.75rem;
    font-weight: 500;
    color: var(--accent);
    letter-spacing: 0.03em;
  }

  .timeline-desc {
    font-size: 0.8rem;
    font-weight: 300;
    line-height: 1.7;
    color: var(--text-muted);
    margin-top: 0.25rem;
  }

  /* Contact */
  .contact-content {
    display: flex;
    flex-direction: column;
    gap: 1.5rem;
    max-width: 480px;
  }

  .contact-lead {
    font-size: 0.85rem;
    font-weight: 300;
    line-height: 1.7;
    color: var(--text-muted);
  }

  .contact-links {
    display: flex;
    flex-direction: column;
    gap: 0;
    border: 1px solid var(--border);
    border-radius: 8px;
    overflow: hidden;
  }

  .contact-link {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0.9rem 1.1rem;
    text-decoration: none;
    border-bottom: 1px solid var(--border);
    transition: background 0.15s;
  }

  .contact-link:last-child {
    border-bottom: none;
  }

  .contact-link:hover {
    background: var(--surface);
  }

  .contact-link-label {
    font-size: 0.7rem;
    font-weight: 500;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: var(--text-muted);
  }

  .contact-link-value {
    font-size: 0.78rem;
    font-weight: 400;
    color: var(--accent);
  }
</style>

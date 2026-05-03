<script>
  import { onMount } from 'svelte';
  import '@google/model-viewer';

  let viewer;

  onMount(() => {
    const target = document.getElementById('top');
    if (!target || !viewer) return;

    const io = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          viewer.setAttribute('auto-rotate', '');
        } else {
          viewer.removeAttribute('auto-rotate');
        }
      },
      { threshold: 0 }
    );
    io.observe(target);
    return () => io.disconnect();
  });
</script>

<model-viewer
  bind:this={viewer}
  src="/ur10.glb"
  auto-rotate
  auto-rotate-delay="0"
  rotation-per-second="30deg"
  interaction-prompt="none"
  disable-zoom
  disable-tap
  disable-pan
  shadow-intensity="0"
  exposure="1"
  camera-orbit="0deg 75deg auto"
></model-viewer>

<style>
  model-viewer {
    position: fixed;
    width: 240px;
    height: 240px;
    top: calc(50vh - 120px);
    left: calc(50vw - 55px - 120px);
    background-color: transparent;
    --poster-color: transparent;
    opacity: calc(1 - var(--t));
    pointer-events: none;
    z-index: 5;
  }
</style>

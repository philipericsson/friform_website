<script lang="ts">
  import { onMount } from 'svelte';

  onMount(() => {
    const script = document.createElement('script');
    script.src = '/scripts/fluid-simulation.js';
    document.body.appendChild(script);

    return () => {
      document.body.removeChild(script);
      (window as any).__friformFluidActive = false;
    };
  });
</script>

<svelte:head>
  <title>FRIFORM | Tech Studio</title>
  <meta name="description" content="Friform is a technology studio based in NYC">
</svelte:head>

<div class="hero-fluid bg-light min-h-[80vh] flex items-center">
  <canvas id="fluid-canvas" class="fluid-canvas"></canvas>
  <div class="container mx-auto px-4 pt-0">
    <div class="max-w-4xl">
      <h1 class="text-4xl md:text-6xl lg:text-7xl font-bold mb-8">
        FRI.<br />
        FORM.<br />
        FRIFORM.
      </h1>
      <p class="text-xl md:text-2xl mb-12">
        Deeply technical AI. Genuinely good design.
      </p>
      <a
        href="/contact"
        class="inline-block bg-dark text-white px-8 py-4 text-lg font-medium hover:bg-opacity-90 transition-all"
      >
        Get in touch
      </a>
    </div>
  </div>
</div>

<section class="py-24 bg-gray mb-[-5rem]">
  <div class="container mx-auto px-4">
    <div class="max-w-4xl mx-auto">
      <h2 class="text-3xl md:text-5xl font-bold mb-16">
        Selected projects
      </h2>

      <!-- Project showcases -->
      <div class="grid md:grid-cols-2 gap-8">
        <div class="bg-light p-6">
          <picture class="block aspect-video mb-4">
            <source srcset="/images/optimized/mobile/killerwhale-mobile.webp" media="(max-width: 767px)" type="image/webp">
            <source srcset="/images/optimized/desktop/killerwhale.webp" media="(min-width: 768px)" type="image/webp">
            <img src="/images/optimized/desktop/killerwhale.webp" alt="AI Agents for Real Estate" class="w-full h-full object-cover">
          </picture>
          <h3 class="text-xl font-bold">AI Agents for Real Estate</h3>
          <p>Property recommendation engine aggregating Sweden's largest real estate sites through automated agent workflows.</p>
        </div>
        <div class="bg-light p-6">
          <picture class="block aspect-video mb-4">
            <source srcset="/images/optimized/mobile/cocktail-mobile.webp" media="(max-width: 767px)" type="image/webp">
            <source srcset="/images/optimized/desktop/cocktail.webp" media="(min-width: 768px)" type="image/webp">
            <img src="/images/optimized/desktop/cocktail.webp" alt="Fine-Tuned LLM Research" class="w-full h-full object-cover">
          </picture>
          <h3 class="text-xl font-bold">Fine-Tuned LLM Research</h3>
          <p>Fine-tuned a large language model on a proprietary dataset to study stylistic pattern transfer, completed as part of a graduate research project at Cornell.</p>
        </div>
      </div>
      
      <div class="mt-16 text-center">
        <a 
          href="/work" 
          class="inline-block border-2 border-dark px-8 py-4 text-lg font-medium hover:bg-dark hover:text-white transition-all"
        >
          View more
        </a>
      </div>
    </div>
  </div>
</section>

<style>
  .hero-fluid {
    position: relative;
    z-index: 0;
    overflow: hidden;
  }

  .fluid-canvas {
    position: absolute;
    inset: 0;
    z-index: -1;
    width: 100%;
    height: 100%;
    display: block;
  }

  .hero-fluid :global(.container) {
    position: relative;
    z-index: 1;
    pointer-events: none;
  }

  .hero-fluid :global(.container a) {
    pointer-events: auto;
  }
</style>
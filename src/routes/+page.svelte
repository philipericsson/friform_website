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

<div class="hero-fluid bg-light min-h-[80svh] flex items-center">
  <canvas id="fluid-canvas" class="fluid-canvas"></canvas>
  <div class="container mx-auto px-4 pt-0">
    <div class="max-w-4xl">
      <h1 class="text-4xl md:text-6xl lg:text-7xl font-bold mb-8">
        FREE.<br />
        FORM. <span class="text-lg md:text-2xl lg:text-3xl font-normal italic opacity-50">[EN]</span><br />
        FRIFORM. <span class="text-lg md:text-2xl lg:text-3xl font-normal italic opacity-50">[SV]</span>
      </h1>
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
        Deeply technical AI.<br />
        Genuinely good design.
      </h2>

      <!-- Project showcases -->
      <div class="grid md:grid-cols-2 gap-8">
        <div class="bg-light p-6">
          <picture class="block aspect-video mb-4">
            <source srcset="/images/optimized/mobile/coins-mobile.webp" media="(max-width: 767px)" type="image/webp">
            <source srcset="/images/optimized/desktop/coins.webp" media="(min-width: 768px)" type="image/webp">
            <img src="/images/optimized/desktop/coins.webp" alt="Custom Agentic AI" class="w-full h-full object-cover">
          </picture>
          <h3 class="text-xl font-bold">Custom Agentic AI</h3>
          <p>Built custom network of AI agents plugging into Plaid and a proprietary database to turn raw financial data into real-time wealth management. Approved for App Store and spun out as standalone startup.</p>
        </div>
        <div class="bg-light p-6">
          <picture class="block aspect-video mb-4">
            <source srcset="/images/optimized/mobile/cocktail-mobile.webp" media="(max-width: 767px)" type="image/webp">
            <source srcset="/images/optimized/desktop/cocktail.webp" media="(min-width: 768px)" type="image/webp">
            <img src="/images/optimized/desktop/cocktail.webp" alt="LLM Finetuning" class="w-full h-full object-cover">
          </picture>
          <h3 class="text-xl font-bold">LLM Finetuning</h3>
          <p>Fine-tuned an open-source LLM on a custom-built dataset to create a domain-specific model purpose-built for generating song lyrics.</p>
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
    margin-top: calc(-1 * var(--header-h));
    padding-top: var(--header-h);
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
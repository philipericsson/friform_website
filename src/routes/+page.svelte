<script lang="ts">
  // Add any necessary imports or logic here
</script>

<svelte:head>
  <title>FRIFORM | Tech Studio</title>
  <meta name="description" content="Friform is a technology studio based in NYC">
</svelte:head>

<div class="bg-primary min-h-[80vh] flex items-center">
  <div class="container mx-auto px-4 pt-0">
    <div class="max-w-4xl">
      <h1 class="text-4xl md:text-6xl lg:text-7xl font-bold mb-8">
        FRI.<br />
        FORM.<br />
        FRIFORM.
      </h1>
      <p class="text-xl md:text-2xl mb-12">
        Bridging the gap between complex backend and exceptional interface.
      </p>
      <a 
        href="/contact" 
        class="inline-block bg-dark text-white px-8 py-4 text-lg font-medium hover:bg-opacity-90 transition-all"
      >
        Work with us
      </a>
    </div>
  </div>
</div>

<section class="py-24">
  <div class="container mx-auto px-4">
    <div class="max-w-4xl mx-auto">
      <h2 class="text-3xl md:text-5xl font-bold mb-16">
        We architect AI-powered systems with technical depth and design precision.
      </h2>
      
      <div class="grid md:grid-cols-2 gap-12 mt-20">
        <div>
          <h3 class="text-2xl font-bold mb-4">Development</h3>
          <p class="text-lg">Full stack integration of AI agent architecture, database solutions, and customized frontend.</p>
        </div>
        <div>
          <h3 class="text-2xl font-bold mb-4">Design</h3>
          <p class="text-lg">Minimalist UI/UX design, iterative prototyping, and functional aesthetics that captures your essence.</p>
        </div>
      </div>
      
      <div class="mt-24 pt-16 border-t border-dark/10">
        <h3 class="text-2xl font-bold mb-4">Our Process</h3>
        <p class="text-lg">We collaborate closely with you to transform your goals into clear technical specifications. We handle the implementation—you get a solution that works.</p>
      </div>
    </div>
  </div>
</section>

<section class="py-24 bg-gray mb-[-5rem]">
  <div class="container mx-auto px-4">
    <div class="max-w-4xl mx-auto">
      <h2 class="text-3xl md:text-5xl font-bold mb-16">
        Recent work
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
          <p>AI agent infrastructure aggregating Sweden's largest real estate websites to give recommendations.</p>
        </div>
        <div class="bg-light p-6">
          <picture class="block aspect-video mb-4">
            <source srcset="/images/optimized/mobile/cocktail-mobile.webp" media="(max-width: 767px)" type="image/webp">
            <source srcset="/images/optimized/desktop/cocktail.webp" media="(min-width: 768px)" type="image/webp">
            <img src="/images/optimized/desktop/cocktail.webp" alt="Custom LLM Finetuning" class="w-full h-full object-cover">
          </picture>
          <h3 class="text-xl font-bold">Custom LLM Finetuning</h3>
          <p>Offline, finetuned large language model at American research institution.</p>
        </div>
      </div>
      
      <div class="mt-16 text-center">
        <a 
          href="/work" 
          class="inline-block border-2 border-dark px-8 py-4 text-lg font-medium hover:bg-dark hover:text-white transition-all"
        >
          View all work
        </a>
      </div>
    </div>
  </div>
</section>
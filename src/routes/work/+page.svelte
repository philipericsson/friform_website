<svelte:head>
  <title>Our Work | FRIFORM</title>
  <meta name="description" content="Portfolio of work from Friform, a technology studio based in NYC">
</svelte:head>

<div class="bg-light min-h-[60vh] flex items-center pt-12">
  <div class="container mx-auto px-4">
    <div class="max-w-4xl mx-auto">
      <h1 class="text-4xl md:text-6xl font-bold mb-8">Our Work</h1>
      
      <div class="grid md:grid-cols-2 gap-8 mt-12">
        <div class="bg-light p-6">
          <picture class="block aspect-video mb-4">
            <source srcset="/images/optimized/mobile/killerwhale-mobile.webp" media="(max-width: 767px)" type="image/webp">
            <source srcset="/images/optimized/desktop/killerwhale.webp" media="(min-width: 768px)" type="image/webp">
            <img src="/images/desktop/redxs.png" alt="AI Agents for Real Estate" class="w-full h-full object-cover">
          </picture>
          <h3 class="text-xl font-bold">AI Agents for Real Estate</h3>
          <p>AI agent infrastructure aggregating Sweden's largest real estate websites to give recommendations.</p>
        </div>
        <div class="bg-light p-6">
          <picture class="block aspect-video mb-4">
            <source srcset="/images/optimized/mobile/eelexflying-mobile.webp" media="(max-width: 767px)" type="image/webp">
            <source srcset="/images/optimized/desktop/eelexflying.webp" media="(min-width: 768px)" type="image/webp">
            <img src="/images/desktop/range_integration.png" alt="Electric Vehicle Range Algorithm" class="w-full h-full object-cover">
          </picture>
          <h3 class="text-xl font-bold">Electric Boat Range Algorithm</h3>
          <p>Integrated machine learning range algorithm with Google Maps API.</p>
        </div>
        <div class="bg-light p-6">
          <picture class="block aspect-video mb-4">
            <source srcset="/images/optimized/mobile/xs1sea-mobile.webp" media="(max-width: 767px)" type="image/webp">
            <source srcset="/images/optimized/desktop/xs1sea.webp" media="(min-width: 768px)" type="image/webp">
            <img src="/images/desktop/xs1sea.JPG" alt="Electric Vehicle App" class="w-full h-full object-cover">
          </picture>
          <h3 class="text-xl font-bold">Electric Vehicle App</h3>
          <p>In-house adaptation of previously externally hosted app.</p>
        </div>
        <div class="bg-light p-6">
          <picture class="block aspect-video mb-4">
            <source srcset="/images/optimized/mobile/cocktail-mobile.webp" media="(max-width: 767px)" type="image/webp">
            <source srcset="/images/optimized/desktop/cocktail.webp" media="(min-width: 768px)" type="image/webp">
            <img src="/images/desktop/gears.png" alt="Custom LLM Finetuning" class="w-full h-full object-cover">
          </picture>
          <h3 class="text-xl font-bold">Custom LLM Finetuning</h3>
          <p>Offline, finetuned large language model at American research institution.</p>
        </div>
      </div>
    </div>
  </div>
</div>

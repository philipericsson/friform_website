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
        We create digital solutions for forward-thinking brands and businesses.
      </h2>
      
      <div class="grid md:grid-cols-2 gap-12 mt-20">
        <div>
          <h3 class="text-2xl font-bold mb-4">Development</h3>
          <p class="text-lg">AI-powered solutions, agent infrastructure, frontend integration, custom applications, and interactive experiences.</p>
        </div>
        <div>
          <h3 class="text-2xl font-bold mb-4">Design</h3>
          <p class="text-lg">Brand identity, UI/UX design, product design, and visual storytelling that captures your essence.</p>
        </div>
      </div>
    </div>
  </div>
</section>

<section class="py-24 bg-gray">
  <div class="container mx-auto px-4">
    <div class="max-w-4xl mx-auto">
      <h2 class="text-3xl md:text-5xl font-bold mb-16">
        Recent work
      </h2>
      
      <!-- Add project showcases here -->
      <div class="grid md:grid-cols-2 gap-8">
        <div class="bg-light p-6">
          <div class="aspect-video bg-primary mb-4"></div>
          <h3 class="text-xl font-bold">Project One</h3>
          <p>Brief description of the project</p>
        </div>
        <div class="bg-light p-6">
          <div class="aspect-video bg-primary mb-4"></div>
          <h3 class="text-xl font-bold">Project Two</h3>
          <p>Brief description of the project</p>
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
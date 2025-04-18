<script lang="ts">
	import '../app.css';

	let { children } = $props();
</script>

<div class="min-h-screen bg-light">
  <header class="fixed top-0 left-0 w-full bg-primary z-50">
    <div class="container mx-auto py-2 px-4">
      <nav class="flex items-center justify-between">
        <!-- Left navigation -->
        <div class="hidden md:flex space-x-8">
          <a href="/" class="hover:underline font-medium">Home</a>
          <a href="/about" class="hover:underline font-medium">About</a>
        </div>
        
        <!-- Center logo -->
        <div class="flex-1 flex justify-center">
          <a href="/" class="text-2xl font-bold flex items-center hover:animate-spin-once cursor-pointer">
            <img src="/images/logo.png" alt="Friform Logo" class="h-16" />
          </a>
        </div>
        
        <!-- Right navigation -->
        <div class="hidden md:flex space-x-8">
          <a href="/work" class="hover:underline font-medium">Work</a>
          <a href="/contact" class="hover:underline font-medium">Contact</a>
        </div>
      </nav>
    </div>
  </header>
  
  <!-- Spacer to prevent content from being hidden behind fixed header -->
  <div class="h-20"></div>
  
  <main>
	{@render children()}
  </main>
  
  <footer class="bg-primary text-dark py-12 mt-20">
	<div class="container mx-auto px-4">
	  <div class="flex flex-col md:flex-row justify-between">
		<div class="mb-8 md:mb-0">
		  <h3 class="text-xl font-bold mb-4">FRIFORM</h3>
		  <p>A tech/design studio based in NYC</p>
		</div>
		<div>
		  <h4 class="text-lg font-semibold mb-4">Contact</h4>
		  <p>hello@friform.nyc</p>
		</div>
	  </div>
	  <div class="mt-12 pt-6 border-t border-dark/20">
		<p>&copy; {new Date().getFullYear()} Friform. All rights reserved.</p>
	  </div>
	</div>
  </footer>
</div>
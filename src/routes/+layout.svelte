<script lang="ts">
	import '../app.css';

	let { children } = $props();
	let mobileMenuOpen = $state(false);

	function toggleMobileMenu() {
		mobileMenuOpen = !mobileMenuOpen;
	}
</script>

<div class="min-h-screen bg-light">
  <header class="fixed top-0 left-0 w-full bg-primary z-50">
    <div class="container mx-auto py-2 px-4">
      <nav class="flex items-center justify-between">
        <!-- Left navigation (desktop) -->
        <div class="hidden md:flex space-x-8">
          <a href="/" class="hover:underline font-medium">Home</a>
          <a href="/work" class="hover:underline font-medium">Work</a>
        </div>
        
        <!-- Mobile menu button -->
        <button class="md:hidden text-dark p-2 focus:outline-none" onclick={toggleMobileMenu} aria-label="Toggle menu">
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" class="w-6 h-6">
            {#if mobileMenuOpen}
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            {:else}
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
            {/if}
          </svg>
        </button>
        
        <!-- Center logo -->
        <div class="flex-1 flex justify-center">
          <a href="/" class="text-2xl font-bold flex items-center hover:animate-spin-once cursor-pointer">
            <img src="/images/logo.png" alt="Friform Logo" class="h-16" />
          </a>
        </div>
        
        <!-- Right navigation (desktop) -->
        <div class="hidden md:flex space-x-8">
          <a href="/about" class="hover:underline font-medium">About</a>
          <a href="/contact" class="hover:underline font-medium">Contact</a>
        </div>
        
        <!-- Invisible placeholder on mobile to balance the hamburger menu -->
        <div class="md:hidden w-6"></div>
      </nav>
    </div>
    
    <!-- Mobile menu (slide down when open) -->
    {#if mobileMenuOpen}
      <div class="md:hidden bg-primary border-t border-black/10 animate-slideDown">
        <div class="container mx-auto py-4 px-4">
          <div class="flex flex-col space-y-4">
            <a href="/" class="hover:underline font-medium py-2" onclick={toggleMobileMenu}>Home</a>
            <a href="/work" class="hover:underline font-medium py-2" onclick={toggleMobileMenu}>Work</a>
            <a href="/about" class="hover:underline font-medium py-2" onclick={toggleMobileMenu}>About</a>
            <a href="/contact" class="hover:underline font-medium py-2" onclick={toggleMobileMenu}>Contact</a>
          </div>
        </div>
      </div>
    {/if}
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
		  <p>A tech studio based in NYC</p>
		</div>
	  </div>
	  <div class="mt-12 pt-6 border-t border-dark/20">
		<p>&copy; {new Date().getFullYear()} Friform LLC. All rights reserved.</p>
	  </div>
	</div>
  </footer>
</div>
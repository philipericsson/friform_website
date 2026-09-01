<script lang="ts">
	import { onMount } from 'svelte';
	import '../app.css';

	let { children } = $props();
	let mobileMenuOpen = $state(false);
	let headerHidden = $state(false);
	let logoCollapsed = $state(false);

	function toggleMobileMenu() {
		mobileMenuOpen = !mobileMenuOpen;
	}

	onMount(() => {
		const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
		let collapseTimer: ReturnType<typeof setTimeout> | undefined;

		if (prefersReducedMotion) {
			logoCollapsed = true;
		} else {
			collapseTimer = setTimeout(() => {
				logoCollapsed = true;
			}, 1400);
		}

		const SHOW_NEAR_TOP = 80; // always show while this close to the top
		const HIDE_THRESHOLD = 10; // ignore tiny scroll jitter

		let lastScrollY = window.scrollY;
		let ticking = false;

		function handleScroll() {
			const currentScrollY = window.scrollY;

			if (mobileMenuOpen) {
				lastScrollY = currentScrollY;
				ticking = false;
				return;
			}

			if (currentScrollY < SHOW_NEAR_TOP) {
				headerHidden = false;
			} else if (currentScrollY > lastScrollY + HIDE_THRESHOLD) {
				headerHidden = true;
			} else if (currentScrollY < lastScrollY - HIDE_THRESHOLD) {
				headerHidden = false;
			}

			lastScrollY = currentScrollY;
			ticking = false;
		}

		function onScroll() {
			if (!ticking) {
				requestAnimationFrame(handleScroll);
				ticking = true;
			}
		}

		window.addEventListener('scroll', onScroll, { passive: true });
		return () => {
			window.removeEventListener('scroll', onScroll);
			clearTimeout(collapseTimer);
		};
	});
</script>

<div class="min-h-screen bg-light">
  <header class="fixed top-0 left-0 w-full z-50 header-slide" class:header-hidden={headerHidden}>
    <div class="container mx-auto py-2 px-4">
      <nav class="flex items-center justify-between">
        <!-- Left navigation (desktop) -->
        <div class="hidden md:flex space-x-8 flex-1">
          <a href="/" class="hover:underline font-medium">Home</a>
          <a href="/work" class="hover:underline font-medium">Work</a>
        </div>

        <!-- Mobile menu button -->
        <button class="md:hidden text-dark p-2 focus:outline-none" onclick={toggleMobileMenu} aria-label={mobileMenuOpen ? 'Close menu' : 'Open menu'}>
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" class="w-6 h-6">
            {#if mobileMenuOpen}
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            {:else}
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
            {/if}
          </svg>
        </button>

        <!-- Logo: right-aligned on mobile, centered from md up -->
        <div class="flex-1 flex justify-end md:justify-center">
          <a href="/" class="flex items-center cursor-pointer" aria-label="Friform home">
            <picture>
              <source srcset="/images/optimized/mobile/logo.webp" media="(max-width: 767px)" type="image/webp">
              <source srcset="/images/optimized/desktop/logo.webp" media="(min-width: 768px)" type="image/webp">
              <img src="/images/logo.png" alt="" class="h-12 w-auto shrink-0" />
            </picture>
            <span class="logo-wordmark text-2xl font-bold tracking-tight" class:logo-wordmark-collapsed={logoCollapsed}>FRIFORM</span>
          </a>
        </div>

        <!-- Right navigation (desktop) -->
        <div class="hidden md:flex space-x-8 flex-1 justify-end">
          <a href="/contact" class="hover:underline font-medium">Contact</a>
        </div>
      </nav>
    </div>
    
    <!-- Mobile menu (slide down when open) -->
    {#if mobileMenuOpen}
      <div class="md:hidden bg-light border-t border-black/10 animate-slideDown">
        <div class="container mx-auto py-4 px-4">
          <div class="flex flex-col space-y-4">
            <a href="/" class="hover:underline font-medium py-2" onclick={toggleMobileMenu}>Home</a>
            <a href="/work" class="hover:underline font-medium py-2" onclick={toggleMobileMenu}>Work</a>
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
  
  <footer class="bg-dark text-light py-6 mt-20">
	<div class="container mx-auto px-4">
	  <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-2 text-sm">
		<p><span class="font-bold">FRIFORM</span> — A tech studio based in NYC</p>
		<p>&copy; {new Date().getFullYear()} Friform. All rights reserved.</p>
	  </div>
	</div>
  </footer>
</div>

<style>
  .header-slide {
    transform: translateY(0);
    transition: transform 0.3s ease;
  }

  .header-hidden {
    transform: translateY(-100%);
  }

  .logo-wordmark {
    display: inline-block;
    overflow: hidden;
    white-space: nowrap;
    max-width: 12rem;
    margin-left: 0.6rem;
    opacity: 1;
    transition: max-width 0.5s ease, margin-left 0.5s ease, opacity 0.4s ease;
  }

  .logo-wordmark-collapsed {
    max-width: 0;
    margin-left: 0;
    opacity: 0;
  }
</style>
<script lang="ts">
	import { onMount } from 'svelte';
	import { afterNavigate } from '$app/navigation';
	import { page } from '$app/state';
	import '../app.css';

	const navLinks = [
		{ href: '/', label: 'Home' },
		{ href: '/work', label: 'Work' },
		{ href: '/contact', label: 'Contact' }
	];

	let { children } = $props();
	let mobileMenuOpen = $state(false);
	let headerHidden = $state(false);
	let logoCollapsed = $state(false);

	function toggleMobileMenu() {
		mobileMenuOpen = !mobileMenuOpen;
		// The trigger is only reachable when the header is showing, but opening the
		// menu should pin it there regardless of where the scroll handler left it.
		if (mobileMenuOpen) headerHidden = false;
	}

	afterNavigate(() => {
		mobileMenuOpen = false;
	});

	// Lock the page behind the overlay. Parking the body at a negative offset is the
	// only variant iOS Safari honours; anything else lets the page scroll underneath
	// and drops you at the top on close.
	let savedScrollY = 0;

	$effect(() => {
		const body = document.body;
		if (mobileMenuOpen) {
			savedScrollY = window.scrollY;
			body.style.position = 'fixed';
			body.style.top = `-${savedScrollY}px`;
			body.style.left = '0';
			body.style.right = '0';
			return () => {
				body.style.position = '';
				body.style.top = '';
				body.style.left = '';
				body.style.right = '';
				window.scrollTo(0, savedScrollY);
			};
		}
	});

	function handleKeydown(event: KeyboardEvent) {
		if (event.key === 'Escape' && mobileMenuOpen) {
			mobileMenuOpen = false;
		}
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

<svelte:window onkeydown={handleKeydown} />

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
        <button
          class="menu-trigger md:hidden text-dark flex items-center justify-center"
          onclick={toggleMobileMenu}
          aria-label={mobileMenuOpen ? 'Close menu' : 'Open menu'}
          aria-expanded={mobileMenuOpen}
          aria-controls="mobile-menu"
        >
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
  </header>

  <!-- Mobile menu: a full-viewport page under the header, not an overlay on top of it -->
  <div
    id="mobile-menu"
    class="mobile-menu bg-light md:hidden"
    class:mobile-menu-open={mobileMenuOpen}
  >
    <div class="container mx-auto px-4">
      <ul class="menu-list">
        {#each navLinks as link, i (link.href)}
          <li style="--i: {i}">
            <a
              href={link.href}
              class="menu-link text-dark"
              class:menu-link-active={page.url.pathname === link.href}
              aria-current={page.url.pathname === link.href ? 'page' : undefined}
            >
              {link.label}
            </a>
          </li>
        {/each}
      </ul>
    </div>
  </div>
  
  <!-- Spacer to prevent content from being hidden behind fixed header -->
  <div class="header-spacer"></div>
  
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
  .menu-trigger {
    /* rem, so the target grows with the reader's font-size setting */
    min-width: 2.75rem;
    min-height: 2.75rem;
    margin-left: -0.5rem;
  }

  .mobile-menu {
    position: fixed;
    inset: 0;
    min-height: 100svh;
    z-index: 40;
    padding-top: var(--header-h);
    overflow-y: auto;
    visibility: hidden;
    opacity: 0;
    /* Opens instantly so the ground is opaque before the items move; fades on close. */
    transition: opacity 0.2s ease, visibility 0s linear 0.2s;
  }

  .mobile-menu-open {
    visibility: visible;
    opacity: 1;
    transition: none;
  }

  .menu-list {
    font-size: clamp(2.25rem, 12vw, 3.5rem);
    font-weight: 700;
    letter-spacing: -0.02em;
    line-height: 1.35;
    /* em, so the offset tracks the fluid type rather than a fixed gap */
    margin-top: 0.3em;
  }

  .menu-list li {
    opacity: 0;
    transform: translateY(0.2em);
  }

  .mobile-menu-open .menu-list li {
    animation: menuItemIn 0.4s ease forwards;
    animation-delay: calc(var(--i) * 60ms);
  }

  @keyframes menuItemIn {
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  .menu-link {
    display: inline-block;
    text-decoration: none;
  }

  .menu-link-active {
    text-decoration: underline;
    /* em keeps the rule hairline-thin relative to whatever size the type resolves to */
    text-decoration-thickness: 0.045em;
    text-underline-offset: 0.1em;
  }

  @media (prefers-reduced-motion: reduce) {
    .mobile-menu {
      transition: none;
    }

    .menu-list li,
    .mobile-menu-open .menu-list li {
      animation: none;
      opacity: 1;
      transform: none;
    }
  }

  .header-spacer {
    height: var(--header-h);
  }

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
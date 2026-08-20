import adapter from '@sveltejs/adapter-static';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';

const config = {
	preprocess: vitePreprocess(),
	kit: { 
		adapter: adapter({
			// Named 404.html (not index.html) so the SPA fallback doesn't overwrite
			// the prerendered homepage, and so GitHub Pages serves it automatically
			// for any route that isn't a static file (e.g. /contact).
			fallback: '404.html'
		})
	}
};

export default config;

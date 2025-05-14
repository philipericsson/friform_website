/** @type {import('./$types').PageLoad} */
export function load() {
  return {
    recaptchaSiteKey: import.meta.env.VITE_RECAPTCHA_SITE_KEY
  };
}

// Disable prerendering for this page
export const prerender = false; 
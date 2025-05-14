/** @type {import('./$types').PageLoad} */
export function load() {
  // Use Vite's replacement feature to embed the value at build time
  const recaptchaSiteKey = import.meta.env.VITE_RECAPTCHA_SITE_KEY;
  
  return {
    recaptchaSiteKey
  };
}

// Disable prerendering for this page
export const prerender = false; 
<script lang="ts">
  import { onMount } from 'svelte';

  /** @type {import('./$types').PageData} */
  export let data;
  
  let recaptchaLoaded = false;
  let recaptchaLoadTimedOut = false;
  let submitDisabled = true;
  let formSubmitResult: { 
    success: boolean; 
    message?: string; 
    error?: string; 
    formData?: { name: string; email: string; message: string } 
  } | null = null;
  let recaptchaWidgetId: number | null = null;
  let recaptchaContainer: HTMLElement | null = null;

  // Define callback functions for reCAPTCHA
  const onRecaptchaVerified = () => {
    submitDisabled = false;
    
    // Find the submit button and update its appearance
    const submitButton = document.querySelector('button[type="submit"]') as HTMLButtonElement;
    if (submitButton) {
      submitButton.classList.remove('opacity-50', 'cursor-not-allowed');
      submitButton.classList.add('hover:bg-opacity-90');
    }
  };
  
  const onRecaptchaExpired = () => {
    submitDisabled = true;
    
    // Find the submit button and update its appearance
    const submitButton = document.querySelector('button[type="submit"]') as HTMLButtonElement;
    if (submitButton) {
      submitButton.classList.add('opacity-50', 'cursor-not-allowed');
      submitButton.classList.remove('hover:bg-opacity-90');
    }
  };
  
  const onRecaptchaError = () => {
    submitDisabled = true;
  };

  // Function to reset reCAPTCHA
  function resetRecaptcha() {
    if (typeof window.grecaptcha !== 'undefined' && window.grecaptcha.reset && recaptchaWidgetId !== null) {
      window.grecaptcha.reset(recaptchaWidgetId);
      submitDisabled = true;
    }
  }

  // Function to manually render reCAPTCHA
  function renderRecaptcha(siteKey: string) {
    if (!recaptchaContainer) {
      return;
    }
    
    if (typeof window.grecaptcha === 'undefined' || typeof window.grecaptcha.render !== 'function') {
      return;
    }
    
    try {
      recaptchaWidgetId = window.grecaptcha.render(recaptchaContainer, {
        'sitekey': siteKey,
        'callback': onRecaptchaVerified,
        'expired-callback': onRecaptchaExpired,
        'error-callback': onRecaptchaError,
        'size': 'normal',
        'theme': 'light'
      });
    } catch (err) {
      // Silent fail - no need to log errors
    }
  }

  onMount(() => {
    // Get reCAPTCHA site key with fallback
    const siteKey = import.meta.env.VITE_RECAPTCHA_SITE_KEY || data.recaptchaSiteKey;

    if (!siteKey) {
      return;
    }

    // Ad blockers / privacy extensions frequently block reCAPTCHA or the EmailJS
    // CDN script outright. If it hasn't loaded within a few seconds, surface a
    // clear message instead of leaving "Loading verification..." spinning forever.
    const recaptchaTimeout = setTimeout(() => {
      if (!recaptchaLoaded) {
        recaptchaLoadTimedOut = true;
      }
    }, 6000);

    // Define onload callback for reCAPTCHA
    window.onRecaptchaLoad = () => {
      clearTimeout(recaptchaTimeout);
      recaptchaLoaded = true;

      // Wait for the next tick to ensure the container is in the DOM
      setTimeout(() => {
        recaptchaContainer = document.getElementById('recaptcha-container');
        if (recaptchaContainer) {
          renderRecaptcha(siteKey);
        }
      }, 100);
    };

    // Remove any existing reCAPTCHA scripts to avoid conflicts
    const existingScript = document.querySelector('script[src*="recaptcha/api.js"]');
    if (existingScript) {
      document.head.removeChild(existingScript);
    }

    // Load reCAPTCHA script with explicit rendering
    const recaptchaScript = document.createElement('script');
    recaptchaScript.src = 'https://www.google.com/recaptcha/api.js?onload=onRecaptchaLoad&render=explicit';
    recaptchaScript.async = true;
    recaptchaScript.defer = true;
    recaptchaScript.onerror = () => {
      recaptchaLoadTimedOut = true;
    };
    document.head.appendChild(recaptchaScript);
    
    // Load EmailJS script
    const emailjsScript = document.createElement('script');
    emailjsScript.src = 'https://cdn.jsdelivr.net/npm/@emailjs/browser@3/dist/email.min.js';
    emailjsScript.async = true;
    emailjsScript.onerror = () => {
      recaptchaLoadTimedOut = true;
    };
    document.head.appendChild(emailjsScript);
    
    emailjsScript.onload = () => {
      // Initialize EmailJS with public key
      try {
        const publicKey = String(import.meta.env.VITE_EMAILJS_PUBLIC_KEY || '');
        
        // Check if emailjs is available
        if (typeof window.emailjs !== 'undefined') {
          window.emailjs.init(publicKey);
        }
      } catch (error) {
        // Silent fail - no need to log errors
      }
    };
    
    // Clean up
    return () => {
      clearTimeout(recaptchaTimeout);
      if (document.head.contains(recaptchaScript)) {
        document.head.removeChild(recaptchaScript);
      }
      if (document.head.contains(emailjsScript)) {
        document.head.removeChild(emailjsScript);
      }
    };
  });

  async function sendEmail(formData: FormData) {
    const name = String(formData.get('from_name') || '');
    const email = String(formData.get('email') || '');
    const message = String(formData.get('message') || '');
    
    // Get reCAPTCHA response token
    const recaptchaResponse = window.grecaptcha && recaptchaWidgetId !== null 
      ? window.grecaptcha.getResponse(recaptchaWidgetId) 
      : '';
    
    // Check if reCAPTCHA was completed
    if (!recaptchaResponse) {
      return Promise.reject(new Error('Please complete the reCAPTCHA verification'));
    }

    if (typeof window.emailjs === 'undefined') {
      return Promise.reject(new Error('The email service failed to load. This is usually caused by an ad blocker or privacy extension, please disable it for this site and try again.'));
    }

    try {
      // Get EmailJS credentials from environment variables
      const serviceId = String(import.meta.env.VITE_EMAILJS_SERVICE_ID);
      const templateId = String(import.meta.env.VITE_EMAILJS_TEMPLATE_ID);
      const publicKey = String(import.meta.env.VITE_EMAILJS_PUBLIC_KEY);
      
      // Send email using EmailJS with reCAPTCHA token
      return await window.emailjs.send(
        serviceId,
        templateId,
        {
          from_name: name,
          email: email,
          message: message,
          'g-recaptcha-response': recaptchaResponse
        },
        publicKey
      );
    } catch (error) {
      throw error;
    }
  }
</script>

<svelte:head>
  <title>Contact | FRIFORM</title>
  <meta name="description" content="Get in touch with Friform, a technology studio based in NYC">
  <style>
    /* Custom styling for reCAPTCHA to make it look better */
    .grecaptcha-badge { 
      visibility: hidden; 
    }
    
    /* Remove default reCAPTCHA border and make it blend better */
    #recaptcha-container iframe {
      border-radius: 4px;
      overflow: hidden;
      box-shadow: 0 1px 3px rgba(0,0,0,0.05);
    }
    
    /* Remove extra padding from reCAPTCHA */
    #recaptcha-container div {
      margin: 0 !important;
    }
    
    /* Clean up reCAPTCHA styling */
    .g-recaptcha {
      transform: scale(0.97);
      transform-origin: left top;
      margin-bottom: -10px;
    }
  </style>
</svelte:head>

<div class="hero-nyc min-h-[50svh] flex items-center relative overflow-hidden">
  <div class="hero-nyc-overlay absolute inset-0"></div>
  <div class="container mx-auto px-4 relative">
    <h1 class="text-[clamp(2rem,9.16vw,3.75rem)] md:text-6xl lg:text-7xl leading-[1.11] md:leading-[1.06] lg:leading-[1.06] tracking-[-0.02em] font-bold text-white">
      GET IN<br />
      TOUCH.
    </h1>
  </div>
</div>

<div class="bg-light py-24">
  <div class="container mx-auto px-4">
    <div class="max-w-4xl mx-auto">
      <div class="grid md:grid-cols-2 gap-12">
        <div>
          <p class="section-label">The name</p>

          <div class="definition">
            <p class="definition-word"><span class="definition-headword">Fri form</span> <span class="definition-tag">[Swedish]</span></p>
            <p class="definition-gloss">Having or being an irregular or asymmetrical shape or design.</p>
          </div>

          <p class="body-copy">In 1933, Finnish architect Alvar Aalto and furniture maker Otto Korhonen solved a technical problem: how to bend solid wood into a leg cheap enough to mass-produce. Their solution, slicing the wood into thin strips and gluing it back together as it bent, became the L-leg, the foundation of Aalto's Stool 60, a design that hasn't needed to change in ninety years.</p>

          <p class="statement">That pairing, technical rigor and design worth living with, is so central to Friform's philosophy that we built our logo around it.</p>

          <div class="colophon">
            <p class="section-label">Studio</p>
            <p class="body-copy">New York, NY</p>
          </div>
        </div>

        <div>
          <p class="section-label">Say hello</p>

          {#if formSubmitResult?.success}
            <div class="bg-dark text-light px-6 py-4 mb-6 animate-slideDown">
              <p class="font-medium text-lg">Message sent. We'll be in touch.</p>
            </div>
          {:else}
            <form 
              class="space-y-4" 
              id="contact-form"
              on:submit|preventDefault={(e) => {
                // Get the form element
                const formElement = e.currentTarget;
                
                // Get field values directly
                const nameInput = formElement.querySelector('[name="from_name"]') as HTMLInputElement;
                const emailInput = formElement.querySelector('[name="email"]') as HTMLInputElement;
                const messageInput = formElement.querySelector('[name="message"]') as HTMLTextAreaElement;
                
                const nameValue = nameInput?.value.trim() || '';
                const emailValue = emailInput?.value.trim() || '';
                const messageValue = messageInput?.value.trim() || '';
                
                // Check if form fields are filled
                let hasErrors = false;
                let errorMessage = '';
                
                if (!nameValue) {
                  hasErrors = true;
                  errorMessage = 'Please enter your name';
                } else if (!emailValue) {
                  hasErrors = true;
                  errorMessage = 'Please enter your email address';
                } else if (!messageValue) {
                  hasErrors = true;
                  errorMessage = 'Please enter your message';
                } else if (submitDisabled) {
                  // Check if reCAPTCHA is verified
                  hasErrors = true;
                  errorMessage = 'Please complete the verification by checking the reCAPTCHA box';
                }
                
                // Show error message if validation fails
                if (hasErrors) {
                  formSubmitResult = {
                    success: false,
                    error: errorMessage,
                    formData: { name: nameValue, email: emailValue, message: messageValue }
                  };
                  return;
                }
                
                // Disable button while sending to prevent multiple submissions
                const submitButton = formElement.querySelector('button[type="submit"]') as HTMLButtonElement;
                if (submitButton) {
                  submitButton.disabled = true;
                  submitButton.textContent = 'Sending...';
                }
                
                // Create FormData object manually
                const formData = new FormData();
                formData.append('from_name', nameValue);
                formData.append('email', emailValue);
                formData.append('message', messageValue);
                
                // Send email via EmailJS
                sendEmail(formData)
                  .then(() => {
                    // Show success message
                    formSubmitResult = { 
                      success: true, 
                      message: 'Your message has been sent successfully!' 
                    };
                    
                    // Reset form and reCAPTCHA
                    formElement.reset();
                    resetRecaptcha();
                    
                    // Re-enable button
                    if (submitButton) {
                      submitButton.disabled = false;
                      submitButton.textContent = 'Send Message';
                    }
                  })
                  .catch((error: unknown) => {
                    // Get error message
                    let errorMessage = 'Unknown error';
                    if (error instanceof Error) {
                      errorMessage = error.message;
                    } else if (typeof error === 'object' && error !== null && 'text' in error) {
                      // EmailJS errors have the shape { status, text }. Surface the
                      // real text instead of discarding it when it's not a reCAPTCHA error.
                      const text = String((error as { text: unknown }).text);
                      errorMessage = text.includes('reCAPTCHA')
                        ? 'reCAPTCHA verification failed. Please check the box again and try submitting.'
                        : text;
                    } else {
                      // A rejection that's neither an Error nor an EmailJS {status, text}
                      // object usually means the network request itself never completed
                      // (e.g. blocked by an ad blocker, privacy extension, or DNS filter).
                      errorMessage = 'The request to the email service was blocked before it could complete. This is usually an ad blocker, privacy extension, or DNS-level filter blocking requests to the email service specifically (separate from reCAPTCHA). Please disable it for this site and try again.';
                    }

                    // Reset reCAPTCHA but keep form data
                    resetRecaptcha();
                    
                    // Show error message with details using stored form values
                    formSubmitResult = { 
                      success: false, 
                      error: `Failed to send email: ${errorMessage}`,
                      formData: { 
                        name: nameValue,
                        email: emailValue,
                        message: messageValue
                      }
                    };
                    
                    // Re-enable button
                    if (submitButton) {
                      submitButton.disabled = false;
                      submitButton.textContent = 'Send Message';
                    }
                  });
              }}
              novalidate
            >
              <div>
                <label for="name" class="field-label">Name</label>
                <input 
                  type="text" 
                  id="name" 
                  name="from_name" 
                  class="w-full p-2 border border-gray" 
                  value={formSubmitResult?.formData?.name || ''}
                  required
                  data-lpignore="true"
                />
              </div>
              <div>
                <label for="email" class="field-label">Email</label>
                <input 
                  type="email" 
                  id="email" 
                  name="email" 
                  class="w-full p-2 border border-gray" 
                  value={formSubmitResult?.formData?.email || ''}
                  required
                  data-lpignore="true"
                />
              </div>
              <div>
                <label for="message" class="field-label">Message</label>
                <textarea 
                  id="message" 
                  name="message" 
                  rows="4" 
                  class="w-full p-2 border border-gray"
                  required
                  data-lpignore="true"
                >{formSubmitResult?.formData?.message || ''}</textarea>
              </div>
              
              {#if formSubmitResult?.error}
                <div class="bg-red-50 border border-red-300 text-red-800 px-6 py-4 rounded-md mb-6">
                  <p class="font-medium">{formSubmitResult.error}</p>
                </div>
              {/if}
              
              <div class="mb-6">
                {#if recaptchaLoaded}
                  <!-- Container for explicit reCAPTCHA rendering without border or label -->
                  <div id="recaptcha-container" class="inline-block"></div>
                {:else if recaptchaLoadTimedOut}
                  <div class="bg-red-50 border border-red-300 text-red-800 px-4 py-3 rounded-md text-sm max-w-sm">
                    Verification failed to load. This is usually caused by an ad blocker or privacy extension. Please disable it for this site and reload the page.
                  </div>
                {:else}
                  <div class="p-2 bg-gray-50 text-sm text-gray-500 animate-pulse">Loading verification...</div>
                {/if}
              </div>
              
              <button 
                type="submit" 
                class="bg-dark text-white px-6 py-3 transition-opacity duration-200 {submitDisabled ? 'opacity-50 cursor-not-allowed' : 'hover:bg-opacity-90'}"
                disabled={submitDisabled}
              >
                Send Message
              </button>
            </form>
          {/if}
        </div>
      </div>
    </div>
  </div>
</div>

<style>
  /* Small tracked label, the device that gives each column a start point. Both
     columns carry one so they share structure. */
  .section-label,
  .field-label {
    font-size: 0.75rem;
    font-weight: 500;
    text-transform: uppercase;
    letter-spacing: 0.12em;
  }

  /* 0.45 resolved to 2.75:1 against white, under the 4.5:1 minimum for text at
     this size. 0.7 gives 5.9:1. */
  .section-label {
    opacity: 0.7;
    margin-bottom: 1.5rem;
  }

  /* Same treatment, but a little stronger: these are doing a job rather than
     marking a section, and they need to stay readable while filling the form. */
  .field-label {
    display: block;
    opacity: 0.85;
    margin-bottom: 0.5rem;
  }

  /* The definition is the column's anchor, so it is set at display size using
     the same recipe as the headings rather than at body size. */
  .definition {
    padding-bottom: 1.5rem;
    border-bottom: 0.0625rem solid rgba(34, 34, 34, 0.15);
    margin-bottom: 1.5rem;
  }

  .definition-word {
    font-size: clamp(1.75rem, 5vw, 2.25rem);
    font-weight: 700;
    letter-spacing: -0.02em;
    line-height: 1.15;
  }

  /* Two words, so keep them on one line: breaking after "Fri" would read as a
     hyphenless split rather than a headword. */
  .definition-headword {
    white-space: nowrap;
  }

  .definition-tag {
    /* em, so the tag keeps its proportion to the word as that scales */
    font-size: 0.4em;
    font-weight: 400;
    font-style: italic;
    /* 0.5 resolved to 3.15:1 against white, under the 4.5:1 minimum at this
       size. 0.7 gives 5.92:1. */
    opacity: 0.7;
    letter-spacing: 0;
  }

  .definition-gloss {
    font-style: italic;
    font-size: 1.125rem;
    line-height: 1.5;
    margin-top: 0.5rem;
    opacity: 0.75;
  }

  .body-copy {
    font-size: 1.0625rem;
    line-height: 1.6;
  }

  /* The thesis of the page, previously the tail of an 84-word block. */
  .statement {
    font-size: 1.25rem;
    line-height: 1.45;
    letter-spacing: -0.01em;
    padding-top: 1.5rem;
    border-top: 0.0625rem solid rgba(34, 34, 34, 0.15);
    margin-top: 1.5rem;
  }

  .colophon {
    margin-top: 2.5rem;
  }

  .colophon .section-label {
    margin-bottom: 0.375rem;
  }

  .hero-nyc {
    background-image: url('/images/optimized/mobile/nyc-mobile.webp');
    background-size: cover;
    background-position: center;
  }

  @media (min-width: 768px) {
    .hero-nyc {
      background-image: url('/images/optimized/desktop/nyc.webp');
    }
  }

  .hero-nyc-overlay {
    background: linear-gradient(180deg, rgba(0, 0, 0, 0.55) 0%, rgba(0, 0, 0, 0.35) 100%);
  }
</style>

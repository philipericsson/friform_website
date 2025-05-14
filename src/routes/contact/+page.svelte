<script lang="ts">
  import { onMount } from 'svelte';

  /** @type {import('./$types').PageData} */
  export let data;
  
  let recaptchaLoaded = false;
  let submitDisabled = true;
  let formSubmitResult: { 
    success: boolean; 
    message?: string; 
    error?: string; 
    formData?: { name: string; email: string; message: string } 
  } | null = null;
  let recaptchaWidgetId: number | null = null;
  let recaptchaContainer: HTMLElement | null = null;

  // Function to reset reCAPTCHA
  function resetRecaptcha() {
    if (typeof window.grecaptcha !== 'undefined' && window.grecaptcha.reset && recaptchaWidgetId !== null) {
      window.grecaptcha.reset(recaptchaWidgetId);
      submitDisabled = true;
    }
  }

  // Define callback functions for reCAPTCHA
  const onRecaptchaVerified = () => {
    console.log('reCAPTCHA verified successfully');
    submitDisabled = false;
  };
  
  const onRecaptchaExpired = () => {
    console.log('reCAPTCHA verification expired');
    submitDisabled = true;
  };
  
  const onRecaptchaError = () => {
    console.error('reCAPTCHA error occurred');
    submitDisabled = true;
  };

  // Function to manually render reCAPTCHA
  function renderRecaptcha(siteKey: string) {
    if (!recaptchaContainer) {
      console.error('reCAPTCHA container element not found');
      return;
    }
    
    if (typeof window.grecaptcha === 'undefined' || typeof window.grecaptcha.render !== 'function') {
      console.error('grecaptcha.render is not available');
      return;
    }
    
    try {
      console.log('Attempting to render reCAPTCHA in container:', recaptchaContainer);
      recaptchaWidgetId = window.grecaptcha.render(recaptchaContainer, {
        'sitekey': siteKey,
        'callback': onRecaptchaVerified,
        'expired-callback': onRecaptchaExpired,
        'error-callback': onRecaptchaError
      });
      console.log('reCAPTCHA rendered with widget ID:', recaptchaWidgetId);
    } catch (err) {
      console.error('Error rendering reCAPTCHA:', err);
    }
  }

  onMount(() => {
    // Get reCAPTCHA site key with fallback
    const siteKey = import.meta.env.VITE_RECAPTCHA_SITE_KEY || data.recaptchaSiteKey;
    
    if (!siteKey) {
      console.error('reCAPTCHA site key is missing');
      return;
    }
    
    console.log('Loading reCAPTCHA site key:', siteKey);
    
    // Define onload callback for reCAPTCHA
    window.onRecaptchaLoad = () => {
      console.log('reCAPTCHA script loaded successfully');
      recaptchaLoaded = true;
      
      // Wait for the next tick to ensure the container is in the DOM
      setTimeout(() => {
        recaptchaContainer = document.getElementById('recaptcha-container');
        renderRecaptcha(siteKey);
      }, 100);
    };
    
    // Load reCAPTCHA script with explicit rendering
    const recaptchaScript = document.createElement('script');
    recaptchaScript.src = 'https://www.google.com/recaptcha/api.js?onload=onRecaptchaLoad&render=explicit';
    recaptchaScript.async = true;
    recaptchaScript.defer = true;
    document.head.appendChild(recaptchaScript);
    
    // Load EmailJS script
    const emailjsScript = document.createElement('script');
    emailjsScript.src = 'https://cdn.jsdelivr.net/npm/@emailjs/browser@3/dist/email.min.js';
    emailjsScript.async = true;
    document.head.appendChild(emailjsScript);
    
    emailjsScript.onload = () => {
      // Initialize EmailJS with public key
      try {
        const publicKey = String(import.meta.env.VITE_EMAILJS_PUBLIC_KEY || '');
        
        // Check if emailjs is available
        if (typeof window.emailjs !== 'undefined') {
          window.emailjs.init(publicKey);
          console.log('EmailJS initialized successfully');
        } else {
          console.error('EmailJS not available after script loaded');
        }
      } catch (error) {
        console.error('Error initializing EmailJS:', error);
      }
    };
    
    // Clean up
    return () => {
      if (document.head.contains(recaptchaScript)) {
        document.head.removeChild(recaptchaScript);
      }
      if (document.head.contains(emailjsScript)) {
        document.head.removeChild(emailjsScript);
      }
    };
  });

  async function sendEmail(formData: FormData, formElement: HTMLFormElement) {
    const name = String(formData.get('from_name') || '');
    const email = String(formData.get('email') || '');
    const message = String(formData.get('message') || '');
    
    // Get reCAPTCHA response token
    const recaptchaResponse = window.grecaptcha && recaptchaWidgetId !== null 
      ? window.grecaptcha.getResponse(recaptchaWidgetId) 
      : '';
    
    console.log('reCAPTCHA response token length:', recaptchaResponse.length);
    
    // Check if reCAPTCHA was completed
    if (!recaptchaResponse) {
      return Promise.reject(new Error('Please complete the reCAPTCHA verification'));
    }
    
    try {
      // Send email using EmailJS with reCAPTCHA token
      const emailResponse = await window.emailjs.send(
        String(import.meta.env.VITE_EMAILJS_SERVICE_ID),
        String(import.meta.env.VITE_EMAILJS_TEMPLATE_ID),
        {
          from_name: name,
          email: email,
          message: message,
          'g-recaptcha-response': recaptchaResponse
        },
        String(import.meta.env.VITE_EMAILJS_PUBLIC_KEY)
      );
      
      console.log('Email sent successfully:', emailResponse);
      return emailResponse;
    } catch (error) {
      console.error('Error sending email:', error);
      throw error;
    }
  }
</script>

<svelte:head>
  <title>Contact | FRIFORM</title>
  <meta name="description" content="Get in touch with Friform, a technology studio based in NYC">
</svelte:head>

<div class="bg-light min-h-[60vh] flex items-center pt-12">
  <div class="container mx-auto px-4">
    <div class="max-w-4xl mx-auto">
      <h1 class="text-4xl md:text-6xl font-bold mb-8">Get in touch</h1>
      
      <div class="grid md:grid-cols-2 gap-12 mt-12">
        <div>
          <h2 class="text-2xl font-bold mb-4">Contact information</h2>
          <p class="mb-2">Email: hello@friform.nyc</p>
          <p class="mb-2">Location: New York, NY</p>
        </div>
        
        <div>
          <h2 class="text-2xl font-bold mb-4">Send us a message</h2>
          <p class="mb-6">We'd love to hear from you. Fill out the form below and we'll get back to you as soon as possible.</p>
          
          {#if formSubmitResult?.success}
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">
              <p>Thank you! Your message has been sent successfully.</p>
            </div>
          {:else}
            <form 
              class="space-y-4" 
              on:submit|preventDefault={(e) => {
                // Send email via EmailJS
                sendEmail(new FormData(e.currentTarget), e.currentTarget)
                  .then(() => {
                    // Show success message
                    formSubmitResult = { 
                      success: true, 
                      message: 'Your message has been sent successfully!' 
                    };
                    
                    // Reset form
                    e.currentTarget.reset();
                    
                    // Reset reCAPTCHA
                    resetRecaptcha();
                  })
                  .catch((error: unknown) => {
                    // Log detailed error
                    console.error('EmailJS error details:', error);
                    
                    // Try to extract more information from the error
                    let errorMessage = 'Unknown error';
                    if (error instanceof Error) {
                      errorMessage = error.message;
                      console.error('Error name:', error.name);
                      console.error('Error stack:', error.stack);
                    } else {
                      console.error('Error type:', typeof error);
                      console.error('Error stringified:', JSON.stringify(error));
                    }
                    
                    // Reset reCAPTCHA
                    resetRecaptcha();
                    
                    // If it's a reCAPTCHA error, show a more helpful message
                    if (errorMessage.includes('reCAPTCHA') || 
                        (typeof error === 'object' && error !== null && 'text' in error && 
                         String(error.text).includes('reCAPTCHA'))) {
                      errorMessage = 'reCAPTCHA verification failed. Please try the following:\n' +
                                    '1. Check the reCAPTCHA box again\n' +
                                    '2. Submit the form within 2 minutes of checking the box\n' +
                                    '3. Try using a different browser or clearing cookies';
                    }
                    
                    // Store form data from the original submission
                    const nameInput = e.currentTarget?.querySelector('[name="from_name"]') as HTMLInputElement;
                    const emailInput = e.currentTarget?.querySelector('[name="email"]') as HTMLInputElement;
                    const messageInput = e.currentTarget?.querySelector('[name="message"]') as HTMLTextAreaElement;
                    
                    const formNameValue = nameInput?.value || '';
                    const formEmailValue = emailInput?.value || '';
                    const formMessageValue = messageInput?.value || '';
                    
                    // Show error message with details
                    formSubmitResult = { 
                      success: false, 
                      error: `Failed to send email: ${errorMessage}`,
                      formData: { 
                        name: formNameValue,
                        email: formEmailValue,
                        message: formMessageValue
                      }
                    };
                  });
              }}
            >
              <div>
                <label for="name" class="block mb-1">Name</label>
                <input 
                  type="text" 
                  id="name" 
                  name="from_name" 
                  class="w-full p-2 border border-gray" 
                  value={formSubmitResult?.formData?.name || ''}
                  required
                />
              </div>
              <div>
                <label for="email" class="block mb-1">Email</label>
                <input 
                  type="email" 
                  id="email" 
                  name="email" 
                  class="w-full p-2 border border-gray" 
                  value={formSubmitResult?.formData?.email || ''}
                  required
                />
              </div>
              <div>
                <label for="message" class="block mb-1">Message</label>
                <textarea 
                  id="message" 
                  name="message" 
                  rows="4" 
                  class="w-full p-2 border border-gray"
                  required
                >{formSubmitResult?.formData?.message || ''}</textarea>
              </div>
              
              {#if formSubmitResult?.error}
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
                  <p>{formSubmitResult.error}</p>
                </div>
              {/if}
              
              <div class="mb-4">
                <label class="block mb-1">Verification</label>
                {#if recaptchaLoaded}
                  <!-- Container for explicit reCAPTCHA rendering with clear border -->
                  <div id="recaptcha-container" class="border border-gray-300 p-2 inline-block min-h-[78px] bg-white"></div>
                  <!-- Debug info -->
                  <div class="text-xs text-gray-400 mt-1">
                    Site key available: {Boolean(import.meta.env.VITE_RECAPTCHA_SITE_KEY || data.recaptchaSiteKey) ? 'Yes' : 'No'}
                  </div>
                {:else}
                  <div class="p-4 bg-gray-100 border border-gray-300">Loading reCAPTCHA verification...</div>
                {/if}
              </div>
              
              <button 
                type="submit" 
                class="bg-dark text-white px-6 py-3 hover:bg-opacity-90 disabled:opacity-50 disabled:cursor-not-allowed"
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

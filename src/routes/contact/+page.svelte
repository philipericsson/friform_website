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
    
    // Define onload callback for reCAPTCHA
    window.onRecaptchaLoad = () => {
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
        }
      } catch (error) {
        // Silent fail - no need to log errors
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

<div class="bg-light min-h-[60vh] flex items-center pt-12">
  <div class="container mx-auto px-4">
    <div class="max-w-4xl mx-auto">
      <h1 class="text-4xl md:text-6xl font-bold mb-8">Get in touch</h1>
      
      <div class="grid md:grid-cols-2 gap-12 mt-12">
        <div>
          <h2 class="text-2xl font-bold mb-4">Need AI?</h2>
          <p class="mb-4">We specialize in integrating AI agents and other deep tech solutions with minimalist design and brand integrity.</p>
          <p class="mb-2">Location: New York, NY</p>
        </div>
        
        <div>
          <h2 class="text-2xl font-bold mb-4">Send us a message</h2>
          <p class="mb-6">We'd love to hear from you. Fill out the form below and we'll get back to you as soon as possible.</p>
          
          {#if formSubmitResult?.success}
            <div class="bg-primary border border-primary text-dark px-6 py-4 rounded-md mb-6 animate-slideDown">
              <p class="font-medium text-lg">Thank you! Your message has been sent successfully.</p>
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
                      // Handle reCAPTCHA errors
                      if (String(error.text).includes('reCAPTCHA')) {
                        errorMessage = 'reCAPTCHA verification failed. Please check the box again and try submitting.';
                      }
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
                <label for="name" class="block mb-1">Name</label>
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
                <label for="email" class="block mb-1">Email</label>
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
                <label for="message" class="block mb-1">Message</label>
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

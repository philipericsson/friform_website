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

  // Function to reset reCAPTCHA
  function resetRecaptcha() {
    if (typeof window.grecaptcha !== 'undefined' && window.grecaptcha.reset) {
      window.grecaptcha.reset();
      submitDisabled = true;
    }
  }

  onMount(() => {
    // Load reCAPTCHA script
    const recaptchaScript = document.createElement('script');
    recaptchaScript.src = 'https://www.google.com/recaptcha/api.js';
    recaptchaScript.async = true;
    recaptchaScript.defer = true;
    document.head.appendChild(recaptchaScript);
    
    recaptchaScript.onload = () => {
      recaptchaLoaded = true;
    };
    
    // Load EmailJS script
    const emailjsScript = document.createElement('script');
    emailjsScript.src = 'https://cdn.jsdelivr.net/npm/@emailjs/browser@3/dist/email.min.js';
    emailjsScript.async = true;
    document.head.appendChild(emailjsScript);
    
    emailjsScript.onload = () => {
      // Initialize EmailJS with public key
      try {
        const publicKey = String(import.meta.env.VITE_EMAILJS_PUBLIC_KEY || '');
        console.log('Initializing EmailJS with public key');
        
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
      document.head.removeChild(recaptchaScript);
      if (document.head.contains(emailjsScript)) {
        document.head.removeChild(emailjsScript);
      }
    };
  });
  
  // Define global functions for reCAPTCHA
  window.onRecaptchaVerified = () => {
    submitDisabled = false;
  };
  
  window.onRecaptchaExpired = () => {
    submitDisabled = true;
  };

  function sendEmail(formData: FormData, formElement: HTMLFormElement) {
    const name = String(formData.get('name') || '');
    const email = String(formData.get('email') || '');
    const message = String(formData.get('message') || '');
    
    // Log values for debugging (remove in production)
    console.log('Sending email with:', {
      name,
      email,
      message: message.substring(0, 20) + '...',
      serviceId: import.meta.env.VITE_EMAILJS_SERVICE_ID,
      templateId: import.meta.env.VITE_EMAILJS_TEMPLATE_ID,
      publicKey: import.meta.env.VITE_EMAILJS_PUBLIC_KEY ? 'Present' : 'Missing'
    });
    
    // Send email with EmailJS's built-in reCAPTCHA integration
    return window.emailjs.sendForm(
      String(import.meta.env.VITE_EMAILJS_SERVICE_ID),
      String(import.meta.env.VITE_EMAILJS_TEMPLATE_ID),
      formElement
    );
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
                {#if recaptchaLoaded}
                  <div 
                    class="g-recaptcha" 
                    data-sitekey={data.recaptchaSiteKey}
                    data-callback="onRecaptchaVerified"
                    data-expired-callback="onRecaptchaExpired"
                  ></div>
                {:else}
                  <div class="p-4 bg-gray-100">Loading reCAPTCHA...</div>
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

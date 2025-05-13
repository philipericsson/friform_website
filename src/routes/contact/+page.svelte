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
          
          <form class="space-y-4">
            <div>
              <label for="name" class="block mb-1">Name</label>
              <input type="text" id="name" class="w-full p-2 border border-gray" />
            </div>
            <div>
              <label for="email" class="block mb-1">Email</label>
              <input type="email" id="email" class="w-full p-2 border border-gray" />
            </div>
            <div>
              <label for="message" class="block mb-1">Message</label>
              <textarea id="message" rows="4" class="w-full p-2 border border-gray"></textarea>
            </div>
            <button type="submit" class="bg-dark text-white px-6 py-3 hover:bg-opacity-90">Send Message</button>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>

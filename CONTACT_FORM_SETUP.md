# Contact Form Setup Instructions

This document explains how to set up the contact form with EmailJS and reCAPTCHA integration.

## 1. Set Up reCAPTCHA

1. Go to the [Google reCAPTCHA Admin Console](https://www.google.com/recaptcha/admin)
2. Sign in with your Google account
3. Register a new site:
   - Enter a label (e.g., "Friform Website")
   - Select reCAPTCHA v2 "I'm not a robot" Checkbox
   - Add your domain(s) - make sure to add your actual production domain
   - Accept the terms and submit
4. You'll receive a Site Key and Secret Key

## 2. Set Up EmailJS

EmailJS allows you to send emails directly from client-side JavaScript without needing your own server:

1. Create an account at [EmailJS](https://www.emailjs.com/)
2. Get your Public Key from the Account > API Keys section
3. Add a new email service (like Gmail, Outlook, etc.)
4. Create an email template:
   - Go to "Email Templates" and create a new template
   - Design your email with variables that match our form field names:
     - `{{from_name}}` - The sender's name
     - `{{email}}` - The sender's email address
     - `{{message}}` - The message content
   - Save the template
5. Add your reCAPTCHA integration:
   - Go to Settings > reCAPTCHA Integration
   - Add your reCAPTCHA secret key
   - Enable reCAPTCHA for your template
6. Note your Service ID, Template ID, and Public Key

## 3. Configure Environment Variables

Create a `.env` file in the root of your project with the following variables:

```
# reCAPTCHA site key (for frontend display only)
VITE_RECAPTCHA_SITE_KEY=your_recaptcha_site_key

# EmailJS keys
VITE_EMAILJS_SERVICE_ID=your_emailjs_service_id
VITE_EMAILJS_TEMPLATE_ID=your_emailjs_template_id
VITE_EMAILJS_PUBLIC_KEY=your_emailjs_public_key
```

Replace the placeholder values with your actual API keys.

## 4. Implementation Notes

- The form uses client-side processing only, allowing the site to be fully prerendered as a static site
- Form submissions are handled by EmailJS's client-side library
- reCAPTCHA verification is integrated directly with EmailJS
- Form field names must match the EmailJS template variables:
  - `from_name` for the name field
  - `email` for the email field
  - `message` for the message field

## 5. Testing the Form

1. Run your development server with `npm run dev`
2. Navigate to the contact page
3. Fill out the form and submit
4. Check that the reCAPTCHA verification works
5. Verify that you receive the email at philipjericsson@gmail.com

**Note:** reCAPTCHA verification may not work correctly on localhost. This is expected behavior and should resolve when deployed to your actual domain.

## 6. Security Considerations

- Never commit your `.env` file to version control
- Set up proper CORS restrictions in your EmailJS account
- Consider rate limiting form submissions to prevent abuse 
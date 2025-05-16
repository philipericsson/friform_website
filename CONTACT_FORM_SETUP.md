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
4. You'll receive two keys:
   - Site Key - for your frontend code
   - Secret Key - for your EmailJS template settings

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
5. **Important**: Configure reCAPTCHA in your template settings:
   - Go to your template settings
   - Find the CAPTCHA tab
   - Enable CAPTCHA verification
   - Enter your reCAPTCHA **Secret Key** (not the site key)
   - Save the settings
6. Note your Service ID, Template ID, and Public Key

## 3. Configure Environment Variables

Create a `.env` file in the root of your project with the following variables:

```
# reCAPTCHA site key
VITE_RECAPTCHA_SITE_KEY=your_recaptcha_site_key

# EmailJS keys
VITE_EMAILJS_SERVICE_ID=your_emailjs_service_id
VITE_EMAILJS_TEMPLATE_ID=your_emailjs_template_id
VITE_EMAILJS_PUBLIC_KEY=your_emailjs_public_key
```

Replace the placeholder values with your actual API keys.

## 4. Implementation Details

Our contact form implementation follows these principles:

- **Static Site Compatible**: The form uses client-side processing only, allowing the site to be fully prerendered
- **Clean UI**: Minimal styling with focus on usability and accessibility
- **Secure**: Uses reCAPTCHA to prevent spam and protects API keys

### Key Components:

1. **Form Initialization**:
   - Loads reCAPTCHA and EmailJS scripts dynamically
   - Initializes EmailJS with your public key
   - Renders reCAPTCHA widget explicitly in a designated container

2. **Form Validation**:
   - Client-side validation for all fields (name, email, message)
   - Ensures reCAPTCHA is verified before submission
   - Provides clear error messages for validation failures

3. **Submission Process**:
   - Disables submit button during submission to prevent double-sends
   - Sends form data to EmailJS with reCAPTCHA token
   - Shows success message on successful submission
   - Preserves form data on error for easy correction

4. **reCAPTCHA Integration**:
   - Uses explicit rendering for better control over appearance
   - Includes callbacks for verification, expiration, and errors
   - Resets automatically after submission

5. **Error Handling**:
   - Graceful handling of network errors
   - Clear user feedback for all error states
   - Preserves form data when errors occur

## 5. GitHub Actions Setup

If deploying with GitHub Actions, add these secrets to your repository:

1. Go to your GitHub repository → Settings → Secrets and variables → Actions
2. Add the following secrets:
   - `VITE_RECAPTCHA_SITE_KEY`
   - `VITE_EMAILJS_SERVICE_ID`
   - `VITE_EMAILJS_TEMPLATE_ID`
   - `VITE_EMAILJS_PUBLIC_KEY`

## 6. Testing the Form

1. Run your development server with `npm run dev`
2. Navigate to the contact page
3. Fill out the form and submit
4. Check that the reCAPTCHA verification works
5. Verify that you receive the email

**Note:** For proper testing, ensure that:
- Your EmailJS template has reCAPTCHA enabled with the correct secret key
- Your environment variables are properly set
- You're testing on a domain registered with reCAPTCHA (or use localhost for development)

## 7. Troubleshooting

If you encounter issues:

1. **reCAPTCHA Not Working**:
   - Verify your site key is correct in environment variables
   - Check that your domain is registered in the reCAPTCHA admin console
   - Look for JavaScript errors in the browser console

2. **Emails Not Sending**:
   - Verify your EmailJS service ID, template ID, and public key
   - Check that reCAPTCHA is properly configured in your EmailJS template settings
   - Ensure your EmailJS account is active and has available email quota

3. **Form Validation Issues**:
   - Check for any JavaScript errors in the console
   - Verify that all form fields are properly named
   - Ensure reCAPTCHA is loading correctly

4. **"invalid-input-response" Error**:
   - This typically means the reCAPTCHA secret key in your EmailJS template settings is incorrect
   - Double-check that you're using the secret key (not the site key) in the EmailJS template settings

## 8. Security Best Practices

- Never commit your `.env` file to version control
- Use environment variables for all sensitive keys
- Set up proper CORS restrictions in your EmailJS account
- Consider rate limiting form submissions to prevent abuse
- Regularly rotate your API keys for enhanced security 
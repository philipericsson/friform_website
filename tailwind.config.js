/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{html,js,svelte,ts}'],
  theme: {
    extend: {
      colors: {
        primary: '#ffe774', // Updated yellow to match logo more precisely
        dark: '#222222',
        light: '#FFFFFF',
        gray: '#F0F0F0'
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
      },
      typography: {
        DEFAULT: {
          css: {
            maxWidth: '80ch',
            color: '#222222',
            h1: {
              fontWeight: '700',
            },
            h2: {
              fontWeight: '600',
            },
          },
        },
      },
      rotate: {
        '360': '360deg',
      },
      animation: {
        'spin-once': 'spin 0.7s linear 1',
        'slideDown': 'slideDown 0.2s ease-out forwards',
      },
      keyframes: {
        spin: {
          from: { transform: 'rotate(0deg)' },
          to: { transform: 'rotate(360deg)' },
        },
        slideDown: {
          '0%': { transform: 'translateY(-10px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        }
      },
    },
  },
  plugins: [require('@tailwindcss/typography')],
};
// See https://svelte.dev/docs/kit/types#app.d.ts
// for information about these interfaces
declare global {
	namespace App {
		// interface Error {}
		// interface Locals {}
		// interface PageData {}
		// interface PageState {}
		// interface Platform {}
	}

	interface Window {
		emailjs: any;
		onRecaptchaVerified: () => void;
		onRecaptchaExpired: () => void;
		grecaptcha: {
			reset: () => void;
			execute: () => void;
			render: (container: string | HTMLElement, parameters: object) => number;
		};
	}
}

export {};

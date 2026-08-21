interface VantaEffect {
	setOptions: (opts: Record<string, unknown>) => void;
	destroy: () => void;
	resize: () => void;
}

declare module 'vanta/dist/vanta.waves.min' {
	export default function WAVES(opts: Record<string, unknown>): VantaEffect;
}

# Friform Website

The official website for Friform, a deep tech & design studio based in NYC. This website showcases our work, philosophy, and services.

## Technology Stack

- **Framework**: SvelteKit
- **Styling**: Tailwind CSS v3
- **Language**: TypeScript

## Design Philosophy

The website follows a minimalist design approach inspired by clean, modern aesthetics. Key features include:

- Centered logo with a playful animation on hover
- Split navigation with a fixed header
- Primary color: pastel yellow (#ffe774)
- Focus on whitespace and typography
- Responsive design for all device sizes

## Development

### Setup

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build
```

## Structure

- `/src/routes/` - Contains all pages and layouts
- `/static/images/` - Image assets including the logo
- `/src/app.css` - Global CSS styles

## Contact

For questions about this website, please contact hello@friform.nyc

## Version Strategy

### Version Format
MAJOR.MINOR.PATCH (X.Y.Z)

### Number Definitions

#### MAJOR Version (X)
- Increment when making incompatible API changes
- Represents breaking changes
- Examples: complete redesigns, removing features, changing how core functionality works

#### MINOR Version (Y)
- Increment when adding functionality in a backward-compatible manner
- Represents new features that don't break existing functionality
- Examples: adding new sections, features, or capabilities

#### PATCH Version (Z)
- Increment when making backward-compatible bug fixes
- Represents maintenance updates and small improvements
- Examples: fixing typos, adjusting colors, fixing broken links

### Additional Rules
- Pre-release versions can be denoted with a hyphen (e.g., 1.0.0-alpha, 1.0.0-beta.2)
- Build metadata can be added with a plus sign (e.g., 1.0.0+20240404)
- Version numbers should never contain leading zeros
- Versions are compared numerically (e.g., 1.10.0 > 1.9.0)

### Examples
- 2.0.0: Major update with breaking changes
- 1.1.0: Added new features (backward-compatible)
- 1.0.1: Bug fixes and minor improvements
- 1.0.0-alpha: Pre-release alpha version
- 1.0.0-beta.2: Second beta pre-release


You can preview the production build with `npm run preview`.

> To deploy your app, you may need to install an [adapter](https://svelte.dev/docs/kit/adapters) for your target environment.

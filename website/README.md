# EEGcellent Website

A modern, responsive website for EEG stress detection technology, built with HTML, CSS, and JavaScript.

## Features

- **Responsive Design**: Works perfectly on desktop, tablet, and mobile devices
- **Interactive Demo**: Real-time stress prediction using EEG channel inputs
- **Modern UI**: Clean, professional design with smooth animations
- **Smooth Navigation**: Fixed navigation bar with smooth scrolling
- **Contact Form**: Functional contact form with validation

## File Structure

```
website/
├── index.html          # Main HTML file
├── styles.css          # CSS styles and responsive design
├── script.js           # JavaScript functionality and interactions
└── README.md           # This file
```

## Sections

1. **Hero Section**: Eye-catching introduction with animated EEG visualization
2. **Problem Section**: Explains the challenges of EEG stress detection
3. **Solution Section**: Showcases the EEGcellent solution with device mockup
4. **Features Section**: Highlights key features of the technology
5. **Demo Section**: Interactive stress prediction demo
6. **Contact Section**: Contact form and company information
7. **Footer**: Additional links and company details

## Interactive Demo

The demo section allows users to:
- Adjust 6 EEG channel values using sliders
- See real-time stress prediction updates
- View stress level as a percentage and visual indicator
- Understand how different EEG values affect stress detection

## How to Use

1. **Open the website**: Simply open `index.html` in any modern web browser
2. **Navigate**: Use the navigation menu to jump to different sections
3. **Try the demo**: Scroll to the demo section and adjust the sliders
4. **Contact**: Fill out the contact form to get in touch

## Browser Compatibility

- Chrome (recommended)
- Firefox
- Safari
- Edge

## Customization

### Colors
The website uses a blue color scheme that can be easily modified in `styles.css`:
- Primary blue: `#2563eb`
- Secondary blue: `#1d4ed8`
- Success green: `#10b981`
- Warning orange: `#f59e0b`
- Error red: `#ef4444`

### Content
- Update text content in `index.html`
- Modify images and icons as needed
- Adjust the demo algorithm in `script.js`

## Integration with Python Model

The demo currently uses a mock algorithm. To integrate with your actual Python stress detection model:

1. Set up a backend server (Flask, Django, etc.)
2. Create an API endpoint that accepts EEG values
3. Modify the `calculateStressScore` function in `script.js` to make API calls
4. Update the stress prediction logic to use real model outputs

## Deployment

To deploy this website:

1. **Static Hosting**: Upload files to services like:
   - GitHub Pages
   - Netlify
   - Vercel
   - AWS S3

2. **Web Server**: Deploy to traditional web servers:
   - Apache
   - Nginx
   - IIS

## Performance

- Optimized CSS and JavaScript
- Responsive images and icons
- Smooth animations with hardware acceleration
- Debounced scroll events for better performance

## License

This website is part of the EEGcellent project. See the main project LICENSE file for details. 
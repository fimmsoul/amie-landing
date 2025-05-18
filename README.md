# Amié UI Prototype

This is a prototype for the Amié dating application UI. It's designed for UI/UX presentation purposes only and doesn't include backend connections or data persistence.

## Features

- Responsive design that mimics the provided mockup
- Interactive elements:
  - Sidebar navigation
  - Toggle switch for auto-matching
  - Clickable buttons 
  - Hover states

## How to View the Prototype

1. Open the `index.html` file in a web browser
2. Interact with the UI elements to see how they respond
3. Resize the browser to see responsive behavior

## Files Included

- `index.html` - Main HTML structure
- `styles.css` - Custom styling
- `script.js` - Interactivity
- `amie-logo.svg` - SVG heart icon

## Notes

- This is a static prototype for UI/UX demonstration only
- No backend functionality is implemented
- The design uses Tailwind CSS for responsive layout and styling

## Interactive Elements

- Click on sidebar menu items to see the active state change
- Toggle the auto-matching switch
- Click "Go to Chatroom" button to see an alert
- Click the "Recharge" button to see an alert
- Click "Log out" to see a confirmation dialog

## Customization

To change colors:
1. Edit the CSS variables in `styles.css`
2. Or modify the Tailwind config in the `index.html` file

```css
/* In styles.css */
:root {
  --primary-color: #FF6C8F;  /* Change this for the main pink color */
  --secondary-color: #6FB6FF; /* Change this for the blue accents */
  /* Other color variables */
}
``` 
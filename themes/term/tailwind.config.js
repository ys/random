const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  plugins: [
    require('@tailwindcss/line-clamp'),
    require("tailwindcss-dark-mode")()
  ],
  variants: {
    backgroundColor: ['dark', 'dark-hover', 'dark-group-hover'],
    borderColor: ['dark', 'dark-focus', 'dark-focus-within'],
    textColor: ['dark', 'dark-hover', 'dark-active']
  },
  theme: {
    screens: {
      sm: "577px",
      md: "768px",
      lg: "992px",
      xl: "1200px"
    },
    extend: {
      fontFamily: {
        mono: ["ia-writer-duo", "ui-monospace", "SFMono-Regular", "Menlo", "Monaco", "Consolas", "Liberation Mono", "Courier New"],
      },
      colors: {
        dark: "#2d2f34",
        darker: "#1F2023"
      }
    }
  }
};

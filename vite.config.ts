import react from "@vitejs/plugin-react";
import { defineConfig } from "vite";
import RubyPlugin from "vite-plugin-ruby";

export default defineConfig({
  plugins: [
    RubyPlugin(),
    // FullReload(["config/routes.rb", "app/views/**/*"], { delay: 100 }),
    react(),
  ],
});

// Import and register all Stimulus controllers
import { application } from "controllers/application"

// Import all controllers from the dummy app
const localControllers = import.meta.glob("./*_controller.js", { eager: true })

for (const path in localControllers) {
  const controller = localControllers[path]
  const name = path
    .replace(/^\.\//, "")
    .replace(/_controller\.js$/, "")
    .replace(/_/g, "-")

  application.register(name, controller.default)
}

export { application }

// Import and register all Stimulus controllers from kumiki engine
// Controllers are automatically registered with the "rails-components--" prefix
// to avoid naming conflicts with host application controllers

import { application } from "./application"

// Import controllers
import AutoDismissController from "./auto_dismiss_controller"
import DismissController from "./dismiss_controller"
import HelloController from "./hello_controller"
import SlideController from "./slide_controller"

// Register controllers with namespace prefix
application.register("rails-components--auto-dismiss", AutoDismissController)
application.register("rails-components--dismiss", DismissController)
application.register("rails-components--hello", HelloController)
application.register("rails-components--slide", SlideController)

export { application }

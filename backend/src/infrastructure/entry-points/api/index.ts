import {UserController} from '@/infrastructure/entry-points/api/users/user-controller'
import {HealthController} from '@/infrastructure/entry-points/api/health-controller'
import {WelcomeController} from "@/infrastructure/entry-points/api/welcome-controller";

export const controllers = [UserController, HealthController, WelcomeController]

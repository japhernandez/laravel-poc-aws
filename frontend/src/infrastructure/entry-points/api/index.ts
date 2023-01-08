import { UserController } from '@/infrastructure/entry-points/api/users/user-controller'
import { HealthController } from '@/infrastructure/entry-points/api/health-controller'

export const controllers = [UserController, HealthController]

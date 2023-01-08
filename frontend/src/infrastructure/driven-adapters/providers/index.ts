import { USER_SERVICE } from '@/domain/use-cases/user-service'
import { UserServiceImpl } from '@/domain/use-cases/impl/users'

// Adaptadores
import { USER_REPOSITORY } from '@/domain/models/contracts/users'
import { UserMongooseRepositoryAdapter } from '../adapters/orm/mongoose'

export const adapters = [
  {
    provide: USER_REPOSITORY,
    useClass: UserMongooseRepositoryAdapter
  }
]

export const services = [
  {
    provide: USER_SERVICE,
    useClass: UserServiceImpl
  }
]

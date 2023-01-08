import { Service, Adapter } from '@tsclean/core'
import { IUserService } from '@/domain/use-cases/user-service'
import { USER_REPOSITORY, IUserRepository } from '@/domain/models/contracts'
import { AddUserParams, UserModel } from '@/domain/models/user'

@Service()
export class UserServiceImpl implements IUserService {
  constructor (
    @Adapter(USER_REPOSITORY)
    private readonly userRepository: IUserRepository
  ) {}

  async save (data: AddUserParams): Promise<UserModel> {
    // TODO: Validar que el usuario sea unico por el email
    // TODO: Encryptar la contraseña
    return this.userRepository.save({
      ...data
    })
  }
}

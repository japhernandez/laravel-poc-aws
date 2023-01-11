import { Adapter, Mapping, Post, Body } from '@tsclean/core'
import { IUserService, USER_SERVICE } from '@/domain/use-cases/user-service'
import { AddUserParams, UserModel } from '@/domain/models/user'

@Mapping('/api/v1/users')
export class UserController {
  constructor (
    @Adapter(USER_SERVICE)
    private readonly userService: IUserService
  ) {}

  @Post()
  async saveUserController (@Body() data: AddUserParams): Promise<UserModel | unknown> {
    // TODO: hacer con class-validator, validaciones de campos
    // TODO: email valid
    const user = await this.userService.save(data)
    return {
      message: 'User created successfully',
      user
    }
  }

  // TODO: CRUD
}

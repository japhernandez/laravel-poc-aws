import { IUserRepository } from '@/domain/models/contracts/users/user-repository'
import { AddUserParams, UserModel } from '@/domain/models/user'
import { UserModelSchema as Schema } from './models'

export class UserMongooseRepositoryAdapter implements IUserRepository {
  async save (data: AddUserParams): Promise<UserModel> {
    return Schema.create(data)
  }
  /**
     * update
     * delete
     * findAll
     * findByParams
     * findById
     */
}

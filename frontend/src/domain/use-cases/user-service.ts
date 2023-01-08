import { AddUserParams, UserModel } from '@/domain/models/user'

export const USER_SERVICE = 'USER_SERVICE'

export interface IUserService {
  save: (data: AddUserParams) => Promise<UserModel>
}

import { AddUserParams, UserModel } from '@/domain/models/user'

export const USER_REPOSITORY = 'USER_REPOSITORY'

// repositorio para las funciones de usuarios
export interface IUserRepository {
  save: (data: AddUserParams) => Promise<UserModel>
  /**
     * update
     * delete
     * findAll
     * findByParam
     * findByid
     */
}

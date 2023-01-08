import { Table, Column, Model, Sequelize } from 'sequelize-typescript'
import { UserModel } from '@/domain/models/user'

@Table({ tableName: 'users' })
export class UserModelMysql extends Model<UserModel> {
  // Implementation
}

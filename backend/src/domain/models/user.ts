export type UserModel = {
  id: number | string
  first_name: string
  last_name: string
  email: string
  password: string
  locale: string
  region: string
  balance: number
  birth_date: Date
  type_of_user: TypeOfUserModel
  is_email_verified: boolean
  is_phone_verified: boolean
  is_profile_complete: boolean
  code_to_verify_email: number
  code_to_verify_phone: number
  code_references: string
  terms: boolean
  accept_newletters: boolean
  last_login: Date
  roles: RolesModel
  document_type: string
  document_number: number | string
  user_name: string
  picture: string
  phone: string
  location: AddressModel
  how_much_willing_to_invest: string
  createdAt: Date
  updatedAt: Date
}

export type AddressModel = {
  address: string
  city: string
  country: string
}
export enum TypeOfUserModel {
  USER = 'user',
  ENTERPRISE = 'enterprise',
  MODERATOR = 'moderator',
  ADMIN = 'admin'
}

export type RolesModel = [
  {
    rol: string
  }
]

export type AddUserParams = Omit<UserModel, 'id' | 'createdAt' | 'updatedAt'>

import { UserModel } from '@/domain/models/user'
import { model, Schema } from 'mongoose'

const schema = new Schema<UserModel>({
  first_name: String,
  last_name: String,
  email: {
    type: String,
    unique: true,
    required: true
  },
  password: {
    type: String,
    required: true
  },
  locale: String,
  region: String,
  balance: {
    type: Number,
    default: 0
  },
  birth_date: Date,
  type_of_user: String,
  is_email_verified: {
    type: Boolean,
    default: false
  },
  is_phone_verified: {
    type: Boolean,
    default: false
  },
  is_profile_complete: {
    type: Boolean,
    default: false
  },
  code_to_verify_email: {
    type: Number,
    default: null
  },
  code_to_verify_phone: {
    type: Number,
    default: null
  },
  code_references: {
    type: String,
    default: null
  },
  terms: Boolean ,
  accept_newletters: Boolean,
  roles: [{ roles: String }],
  last_login: Date,
  document_type: String,
  document_number: Number,
  user_name: String,
  picture: String,
  phone: String,
  location: {
    address: String,
    city: String,
    country: String
  },
  how_much_willing_to_invest: String
},
{
  timestamps: true, strict: false
})

export const UserModelSchema = model<UserModel>('users', schema)

import 'module-alias/register'

import helmet from 'helmet'
import { connect, set } from 'mongoose'

import { Sequelize } from 'sequelize-typescript'

import { StartProjectInit } from '@tsclean/core'

import { AppContainer } from '@/application/app'
import {
  PORT,
  CONFIG_MYSQL,
  MONGODB_URI
} from '@/application/config/environment'
import { UserModelMysql } from '@/infrastructure/driven-adapters/adapters/orm/sequelize/models/user-mysql'

// async function managerConnectionCreate (): Promise<void> {
//   const sequelize = new Sequelize(
//     CONFIG_MYSQL.database,
//     CONFIG_MYSQL.user,
//     CONFIG_MYSQL.password,
//     {
//       host: CONFIG_MYSQL.host,
//       dialect: 'mysql',
//       models: [UserModelMysql]
//     }
//   )
//
//   await sequelize.authenticate()
// }
//
// async function managerConnectioMongo (): Promise<void> {
//   set('strictQuery', true)
//   await connect(MONGODB_URI)
// }

async function init (): Promise<void> {
  // await managerConnectionCreate().then(() =>
  //   console.log(
  //     `Connection successfully to database of MySQL: ${CONFIG_MYSQL.database}`
  //   )
  // )
  //
  // await managerConnectioMongo().then(() =>
  //   console.log(`Connection successfully to database of Mongo: ${MONGODB_URI}`)
  // )

  const app = await StartProjectInit.create(AppContainer)
  app.use(helmet())
  await app.listen(PORT, () => console.log('Running on port ' + PORT))
}

void init().catch((err) => console.log(err))

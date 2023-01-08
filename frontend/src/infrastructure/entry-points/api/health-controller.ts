import { Get, Mapping } from '@tsclean/core'

@Mapping('/')
export class HealthController {
  @Get()
  async getHealthController (): Promise<string> {
    return JSON.stringify('Welcome Suitme to AWS')
  }
}

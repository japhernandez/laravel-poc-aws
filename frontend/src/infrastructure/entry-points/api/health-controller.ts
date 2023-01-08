import { Get, Mapping } from '@tsclean/core'

@Mapping('/api/v1/health')
export class HealthController {
  @Get()
  async getHealthController (): Promise<string> {
    return JSON.stringify('Welcome Suitme to AWS')
  }
}

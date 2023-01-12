import { Get, Mapping } from '@tsclean/core'

@Mapping('/api/health')
export class HealthController {
  @Get()
  async getHealthController (): Promise<string> {
    return JSON.stringify('Welcome Suitme to AWS and ci, cd integration')
  }
}

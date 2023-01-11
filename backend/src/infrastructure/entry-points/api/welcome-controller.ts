import { Get, Mapping } from '@tsclean/core'

@Mapping('/api/')
export class WelcomeController {
  @Get()
  async getWelcomeController (): Promise<string> {
    return JSON.stringify('Welcome Suitme to AWS')
  }
}

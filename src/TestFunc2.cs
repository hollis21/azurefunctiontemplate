using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace LocalFunctionProj;

public class TestFunc2
{
  private readonly ILogger<TestFunc2> logger;

  public TestFunc2(ILogger<TestFunc2> logger)
  {
    this.logger = logger;
  }

  [Function("TestFunc2")]
  public void Run([TimerTrigger("00:02:00")] TimerInfo timerInfo, FunctionContext functionContext) {
    logger.LogInformation("Timer went off!");
    logger.LogWarning("A timer warning?!");
  }
}
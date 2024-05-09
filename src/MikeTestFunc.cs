using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace LocalFunctionProj
{
    public class MikeTestFunc
    {
        private readonly ILogger<MikeTestFunc> _logger;

        public MikeTestFunc(ILogger<MikeTestFunc> logger)
        {
            _logger = logger;
        }

        [Function("MikeTestFunc")]
        public IActionResult Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequest req)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");
            _logger.LogWarning("A warning! Oh no! Foobar!");
            return new OkObjectResult("Welcome to Azure Functions 3!");
        }
    }
}

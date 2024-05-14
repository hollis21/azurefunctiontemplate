using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;

namespace LocalFunctionProj
{
    public class MikeTestFunc
    {
        private readonly IConfiguration configuration;
        private readonly ILogger<MikeTestFunc> logger;

        public MikeTestFunc(IConfiguration configuration, ILogger<MikeTestFunc> logger)
        {
            this.configuration = configuration;
            this.logger = logger;
        }

        [Function("MikeTestFunc")]
        public IActionResult Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequest req)
        {
            logger.LogInformation(configuration["Test"]);
            logger.LogInformation("C# HTTP trigger function processed a request.");
            logger.LogWarning("A warning! Oh no! Foobar!");
            return new OkObjectResult("Welcome to Azure Functions 3!");
        }
    }
}

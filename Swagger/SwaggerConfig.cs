using System.Web.Http;
using Swashbuckle.Application;

namespace UserPatchApi.Swagger
{
    public static class SwaggerConfig
    {
        public static void Register(HttpConfiguration config)
        {
            config
                .EnableSwagger(c =>
                {
                    c.SingleApiVersion(
                        "v1",
                        "UserPatch API");
                })
                .EnableSwaggerUi();
        }
    }
}

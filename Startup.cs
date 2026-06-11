using System.Web.Http;
using Owin;
using WebApiThrottle;

namespace UserPatchApi
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            var config = new HttpConfiguration();

            // Attribute routing
            config.MapHttpAttributeRoutes();

            // Rate limiting — 10 requests per minute per IP (429 on breach)
            // config.MessageHandlers.Add(new ThrottlingHandler()
            // {
            //     Policy = new ThrottlePolicy(perMinute: 10)
            //     {
            //         IpThrottling = true
            //     },
            //     Repository = new CacheRepository()
            // });

            app.UseWebApi(config);
        }
    }
}

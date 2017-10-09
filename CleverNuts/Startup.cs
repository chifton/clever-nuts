using Microsoft.Owin;
using Owin;

[assembly: OwinStartup(typeof(CleverNuts.Startup))]
namespace CleverNuts
{

    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            app.MapSignalR();
        }
    }
}

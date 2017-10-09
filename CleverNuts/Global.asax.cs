using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using Microsoft.Owin;

namespace CleverNuts
{
    // Remarque : pour obtenir des instructions sur l'activation du mode classique IIS6 ou IIS7, 
    // visitez http://go.microsoft.com/?LinkId=9394801

    public class MvcApplication : System.Web.HttpApplication
    {

        public static long compteurglobal { get; set; }

        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();

            WebApiConfig.Register(GlobalConfiguration.Configuration);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            BundleMobileConfig.RegisterBundles(BundleTable.Bundles);
            AuthConfig.RegisterAuth();

            // Pour compter le nombre total de visiteurs
            compteurglobal = 0;
            Application["numberNutters"] = compteurglobal.ToString();

            // Pour initialiser la variable globale qui vérifie si facebook nutter ou site nutter
            //HttpContext.Current.Application["fbkornot"] = "site";
        }

        void Session_Start(object sender, EventArgs e)
        {
            compteurglobal = Convert.ToInt32(Application["numberNutters"]);
            compteurglobal = compteurglobal + 1;
            Application["numberNutters"] = compteurglobal.ToString();

            // Pour initialiser la variable globale qui vérifie si facebook nutter ou site nutter
            //HttpContext.Current.Application["fbkornot"] = "site";
            HttpContext.Current.Session["fbkornot"] = "site";
        }


        void Session_End(object sender, EventArgs e)
        {
            compteurglobal = compteurglobal - 1;
            Application["numberNutters"] = compteurglobal.ToString();
            OnlineActiveUsers.OnlineUsersInstance.OnlineUsers.UpdateForUserLeave();
        }

    }
}
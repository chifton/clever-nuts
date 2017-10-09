using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;

namespace CleverNuts.Controllers
{
    public class ServeurFbkController : ApplicationRealController
    {
        //
        // GET: /ServeurFbk/

        public ActionResult Index()
        {

            return View();

        }

        
        public string Get([FromUri] string mode, [FromUri] string challenge, [FromUri] string verifyToken)
            {
                string param1 = this.Request.QueryString["hub.mode"];
                string param2 = this.Request.QueryString["hub.challenge"];
                string param3 = this.Request.QueryString["hub.verify_token"];

                if (param3 == "coumba")
                {
                    return param2;
                }
                else
                {
                    return "";
                }
            }

    }
}

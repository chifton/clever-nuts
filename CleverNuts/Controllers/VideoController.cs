using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CleverNuts.Controllers
{
    public class VideoController : ApplicationRealController
    {
        //
        // GET: /Video/

        public ActionResult Index()
        {
            return View();
        }

    }
}

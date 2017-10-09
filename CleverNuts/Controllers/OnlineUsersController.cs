using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CleverNuts.Controllers
{
    public class OnlineUsersController : ApplicationRealController
    {
        //
        // GET: /OnlineUsers/

        public ActionResult Index()
        {
            return View();
        }

    }
}

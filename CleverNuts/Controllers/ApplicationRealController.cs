using CleverNuts.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CleverNuts.Controllers
{
    public class ApplicationRealController : ApplicationController
    {
        //
        // GET: /ApplicationReal/

        //public ActionResult Index()
        //{
        //    return View();
        //}

        public string RegisterAllFbk(string idfk, string usernamefk, string emailfk)
        {
            try
            {
                ViewData["ici"] = "facebook";
                ViewData["idfbk"] = idfk;
                ViewBag.idfbk = idfk;
                System.Web.HttpContext.Current.Session["idfbk"] = idfk;
                System.Web.HttpContext.Current.Session["fbkornot"] = "fbk";
                string valeurglobale = System.Web.HttpContext.Current.Session["idfbk"] as string;
                AWLFacebookContext contexte = new AWLFacebookContext();
                string usernamereal = contexte.FacebookNuttersTable.FirstOrDefault(u => u.UserId.Equals(valeurglobale)).UserName;
                ViewData["fbk"] = usernamereal;
                ViewBag.fbk = usernamereal;
                return "KO";

                // APPEL NOM ICI
                return "OK";
            }
            catch(Exception ex)
            {
                return ex.ToString();
            }
        }
    }
}

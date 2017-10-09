using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CleverNuts.Models;
using System.Web.Security;
using DotNetOpenAuth.AspNet;
using System.Diagnostics;
using Microsoft.Web.WebPages.OAuth;
using WebMatrix.WebData;
using CleverNuts.Filters;
using CleverNuts.Services;


namespace CleverNuts.Controllers
{
        public abstract class ApplicationController : Controller
        {
            bool enregistreProfil;

            public ApplicationController()
            {
                // Pour le facebooker dans sa partial view
                ViewData["fbk"] = "Loading... Wait !";

                string valeur = System.Web.HttpContext.Current.Session["fbkornot"] as string;
                if(valeur == "fbk")
                {
                    ViewData["ici"] = "facebook";
                    if (ViewData["idfbk"] == null || ViewBag.idfbk == null)
                    {
                        ViewData["idfbk"] = "";
                        ViewBag.idfbk = "";
                    }
                }
                else if (valeur == "site")
                {
                    ViewData["ici"] = "site";
                

                enregistreProfil = (System.Web.HttpContext.Current.User != null) && System.Web.HttpContext.Current.User.Identity.IsAuthenticated;
                if (enregistreProfil)
                    {
                        UsersContext db = new UsersContext();
                        UserProfile user = db.UserProfiles.FirstOrDefault(u => u.UserName.Equals(System.Web.HttpContext.Current.User.Identity.Name));
                        ViewData["noix1"] = user.UserNuts1;
                        ViewData["noix2"] = user.UserNuts2;
                        ViewData["noix3"] = user.UserNuts3;
                        ViewData["noixb"] = user.UserBonus;
                    }
                }
            }
        }
}